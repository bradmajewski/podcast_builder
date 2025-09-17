require "test_helper"

class SFTPClientTest < ActiveSupport::TestCase
  def setup
    @sftp = SFTP::Client.new(servers(:dev)).start
  end

  def teardown
    @sftp&.close
  end

  test "connects to SFTP server" do
    filenames = @sftp.list_files "/config" # This is the home folder for the container
    assert_instance_of Array, filenames
  end

  test "creates a path" do
    root = "test_directory"
    path = "#{root}/path"
    @sftp.rm_f(root)

    @sftp.find_or_create_path(path)
    assert_equal "directory", @sftp.file_type(path), "Directory \"#{path}\" was not created."
  end

  test "writes to a file" do
    file = "test_file"
    @sftp.rm_f(file)

    bytes_written = @sftp.write_file(file, "test")
    assert_equal 4, bytes_written, "Expected 4 bytes, got #{bytes_written}"
    assert_equal "regular", @sftp.file_type(file), "File was not created."

    file_contents = @sftp.read_file(file)
    assert_equal "test", file_contents, "File contents are incorrect: (#{file_contents.inspect})"
  end

  test "lists files" do
    path = "test_list"
    @sftp.rm_f(path)

    expected_files = ["first", "second"]
    expected_files.each { |file| @sftp.find_or_create_path("#{path}/#{file}") }

    files = @sftp.list_files(path)
    assert_equal expected_files.sort, files.sort, "Directory \"#{path}\" contents are incorrect: (#{files.inspect})"
  end
end
