require "rails_helper"

describe Image do
  describe "formatted_filename" do
    let(:name)      { "cat.gif" }
    let(:version)   { "thumb" }
    let(:suffix)    { "smaller" }
    let(:extension) { "jpg" }

    it "returns a nicely formatted filename" do
      result = Image.new.formatted_filename(name, version, suffix, extension)

      expect(result).to eq "cat_smaller.jpg"
    end

    it "returns a nicely formatted filename when the version got prepended" do
      version_name = "#{version}_#{name}"

      result = Image.new.formatted_filename(version_name, version, suffix, extension)

      expect(result).to eq "cat_smaller.jpg"
    end
  end
end
