# frozen_string_literal: true

RSpec.describe OmniAI::Tools::Disk::LocalDriver do
  let(:driver) { described_class.new(root:) }
  let(:root) { Dir.mktmpdir }

  describe "#directory_create" do
    subject(:create_directory) { driver.directory_create(path:) }

    let(:path) { "foo/bar" }

    it "creates a directory" do
      expect { create_directory }.to change { Dir.exist?(File.join(root, path)) }.from(false).to(true)
    end
  end

  describe "#directroy_delete" do
    subject(:delete_directory) { driver.directroy_delete(path:) }

    let(:path) { "foo/bar" }

    it "deletes a directory" do
      FileUtils.mkdir_p(File.join(root, path))
      expect { delete_directory }.to change { Dir.exist?(File.join(root, path)) }.from(true).to(false)
    end
  end

  describe "#directory_list" do
    subject(:directory_list) { driver.directory_list }

    let(:root) { ROOT.join("spec", "fixtures", "project") }

    it "returns a summary of the project contents" do
      expect(directory_list).to eql(<<~TEXT.strip)
        📄 ./Dockerfile (178 bytes)
        📄 ./Gemfile (88 bytes)
        📄 ./compose.yml (70 bytes)
        📁 ./lib/
        📄 ./lib/greet.rb (85 bytes)
      TEXT
    end
  end

  describe "#directory_move" do
    subject(:directroy_move) { driver.directory_move(path:, destination:) }

    let(:path) { "source" }
    let(:destination) { "destination" }

    before do
      FileUtils.mkdir_p(File.join(root, path))
    end

    it "deletes ./source" do
      expect { directroy_move }.to change { Dir.exist?(File.join(root, path)) }.from(true).to(false)
    end

    it "creates ./destination" do
      expect { directroy_move }.to change { Dir.exist?(File.join(root, destination)) }.from(false).to(true)
    end
  end

  describe "#file_create" do
    subject(:file_create) { driver.file_create(path:) }

    let(:path) { "README.md" }

    it "creates a file" do
      expect { file_create }.to change { File.exist?(File.join(root, path)) }.from(false).to(true)
    end
  end

  describe "#file_delete" do
    subject(:file_delete) { driver.file_delete(path:) }

    let(:path) { "README.md" }

    before do
      FileUtils.touch(File.join(root, path))
    end

    it "deletes a file" do
      expect { file_delete }.to change { File.exist?(File.join(root, path)) }.from(true).to(false)
    end
  end

  describe "#file_move" do
    subject(:file_move) { driver.file_move(path:, destination:) }

    let(:path) { "README.txt" }
    let(:destination) { "README.md" }

    before do
      FileUtils.touch(File.join(root, path))
    end

    it "deletes ./README.txt" do
      expect { file_move }.to change { File.exist?(File.join(root, path)) }.from(true).to(false)
    end

    it "creates ./README.md" do
      expect { file_move }.to change { File.exist?(File.join(root, destination)) }.from(false).to(true)
    end
  end

  describe "#file_read" do
    subject(:file_read) { driver.file_read(path:) }

    let(:path) { "README.md" }

    before do
      File.write(File.join(root, "README.md"), "Hello World")
    end

    it "reads from a file" do
      expect(file_read).to eql("Hello World")
    end
  end

  describe "#file_replace" do
    subject(:file_replace) { driver.file_replace(old_text:, new_text:, path:) }

    let(:path) { "README.md" }
    let(:old_text) { "George" }
    let(:new_text) { "Ringo" }

    before do
      File.write(File.join(root, path), "Hello George")
    end

    it "replaces the contents of a file" do
      expect { file_replace }.to change { File.read(File.join(root, path)) }.from("Hello George").to("Hello Ringo")
    end
  end

  describe "#file_write" do
    subject(:file_write) { driver.file_write(path:, text:) }

    let(:path) { "README.md" }
    let(:text) { "Hello World" }

    it "writes to a file" do
      expect { file_write }.to change { File.exist?(File.join(root, path)) }.from(false).to(true)
    end
  end
end
