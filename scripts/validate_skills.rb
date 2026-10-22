#!/usr/bin/env ruby
# Validate this bundle's metadata and relative inline links without extra gems.
require 'yaml'
require 'pathname'

class SkillBundleValidator
  def initialize(root)
    @root = File.expand_path(root)
    @errors = []
    @links = 0
  end

  def run
    skills = Dir.glob(File.join(@root, 'skills', '*', 'SKILL.md')).sort
    @errors << 'No skills/*/SKILL.md found' if skills.empty?
    documents = Dir.glob(File.join(@root, '**', '*.md')).sort
    documents.each do |path|
      body = File.read(path, encoding: 'UTF-8')
      validate_metadata(path, body) if skills.include?(path)
      validate_markdown(path, body)
    end
    { skills: skills.length, documents: documents.length,
      local_links: @links, errors: @errors }
  end

  private

  def error(path, message)
    @errors << "#{Pathname.new(path).relative_path_from(Pathname.new(@root))}: #{message}"
  end

  def validate_metadata(path, body)
    match = body.match(/\A---\r?\n(.*?)\r?\n---(?:\r?\n|\z)/m)
    return error(path, 'Missing YAML frontmatter') unless match

    begin
      metadata = YAML.safe_load(match[1])
    rescue Psych::Exception => exception
      return error(path, "Invalid YAML: #{exception.class}")
    end
    return error(path, 'Frontmatter must be a mapping') unless metadata.is_a?(Hash)

    name = metadata['name']
    unless name.is_a?(String) && name.match?(/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/) && name.length <= 64
      error(path, 'name must be lowercase kebab-case with at most 64 characters')
    end
    error(path, 'name differs from folder') unless name == File.basename(File.dirname(path))
    description = metadata['description']
    unless description.is_a?(String) && !description.strip.empty?
      error(path, 'description must be a nonempty string')
    end
    if description.is_a?(String) && description.length > 1024
      error(path, 'description must have at most 1024 characters')
    end
    error(path, 'Empty skill body') if body[match.end(0)..-1].strip.empty?
  end

  def validate_markdown(path, body)
    fence = nil
    body.each_line.with_index(1) do |line, number|
      marker = line.match(/^ {0,3}(`{3,}|~{3,})(.*)$/)
      if marker
        token, suffix = marker.captures
        if fence.nil?
          fence = token
        elsif token[0] == fence[0] && token.length >= fence.length && suffix.strip.empty?
          fence = nil
        end
        next
      end
      next if fence

      line.scan(/\[[^\]\n]+\]\(([^)\n]+)\)/).flatten.each do |target|
        next if target.start_with?('#') || target.match?(/\A[a-z][a-z0-9+.-]*:/i)

        @links += 1
        target = target.sub(/#.*/, '')
        if Pathname.new(target).absolute?
          error(path, "Line #{number}: absolute file link is not portable")
        elsif !File.exist?(File.expand_path(target, File.dirname(path)))
          error(path, "Line #{number}: missing link target #{target}")
        end
      end
    end
    error(path, 'Unclosed code fence') if fence
  end
end

if __FILE__ == $PROGRAM_NAME
  root = ARGV[0] || File.expand_path('..', __dir__)
  result = SkillBundleValidator.new(root).run
  puts "#{result[:skills]} skills, #{result[:documents]} documents, #{result[:local_links]} local links"
  result[:errors].each { |message| warn message }
  puts(result[:errors].empty? ? 'PASS' : 'FAIL')
  exit(result[:errors].empty? ? 0 : 1)
end
