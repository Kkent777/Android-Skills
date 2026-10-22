#!/usr/bin/env ruby
require 'minitest/autorun'
require 'tmpdir'
require 'fileutils'
require 'open3'
require 'rbconfig'
require 'yaml'

class SkillBundleValidatorTest < Minitest::Test
  SCRIPT = File.expand_path('validate_skills.rb', __dir__)

  def assert_validation(expected, name: 'sample-skill', description: 'Maintain sample data.',
                        body: 'Read the current data contract.', content: nil)
    Dir.mktmpdir('skill-validator-test-') do |root|
      folder = File.join(root, 'skills', name)
      FileUtils.mkdir_p(File.join(folder, 'references'))
      File.write(File.join(folder, 'references', 'case.md'), "# Case\n")
      document = content || YAML.dump('name' => name, 'description' => description) + "---\n\n#{body}\n"
      File.write(File.join(folder, 'SKILL.md'), document)
      stdout, stderr, status = Open3.capture3(RbConfig.ruby, SCRIPT, root)
      assert_equal expected, status.exitstatus, "#{stdout}\n#{stderr}"
      assert_includes stdout, expected.zero? ? 'PASS' : 'FAIL'
    end
  end

  def test_valid_bundle_and_reference
    assert_validation 0, body: 'Read [case](references/case.md).'
  end

  def test_missing_frontmatter
    assert_validation 1, content: "# Skill\nBody\n"
  end

  def test_invalid_yaml
    assert_validation 1, content: "---\nname: [\n---\nBody\n"
  end

  def test_frontmatter_must_be_mapping
    assert_validation 1, content: "---\n- item\n---\nBody\n"
  end

  def test_name_must_match_folder
    assert_validation 1, content: "---\nname: other-skill\ndescription: Useful skill\n---\nBody\n"
  end

  def test_blank_description
    assert_validation 1, description: ' '
  end

  def test_non_string_description
    assert_validation 1, description: 123
  end

  def test_empty_body
    assert_validation 1, body: ''
  end

  def test_missing_reference
    assert_validation 1, body: '[case](references/missing.md)'
  end

  def test_unclosed_code_fence
    assert_validation 1, body: "```text\nExample\n"
  end

  def test_ignore_links_inside_code_fence
    assert_validation 0, body: "```text\n[example](missing.md)\n```\n"
  end

  def test_name_at_64_character_limit
    assert_validation 0, name: 's' * 64
  end

  def test_name_over_limit
    assert_validation 1, name: 's' * 65
  end

  def test_description_at_1024_character_limit
    assert_validation 0, description: 'd' * 1024
  end

  def test_description_over_limit
    assert_validation 1, description: 'd' * 1025
  end

  def test_absolute_file_link
    assert_validation 1, body: '[file](/etc/hosts)'
  end
end
