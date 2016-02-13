require "spec_helper"
require "digest/sha2"

RSpec.describe "Manual" do
  # JRuby's zlib is a bit quirky. It sometimes produces different output to
  # libzlib (used by MRI). It's still a proper deflate stream and can be
  # decompressed just fine but for whatever reason compressin produses different
  # output.
  #
  # See: https://github.com/jruby/jruby/issues/4244
  let(:manual_hash) do
    case RUBY_ENGINE
    when "ruby"
      "27c720a55936346502cfd8ba46fb0f7db2f16ffba93cda182a6034929ec1e3f7c92bdd0ad609c9f8a54d8d7a8b933f55ef0a06afb3e272ca1a847360cc9d1838"
    when "jruby"
      "9559d2e4ce4acf1d97f6d8b3844091a2f7c9031c22ccaf2e05b6a45108faa3c60faa1502c40944575c15c096dba8d0c249c642264db94c11fa753c8c09dd16a4"
    end
  end

  it "contains no unexpected changes" do
    ENV["CI"] ||= "true"

    require File.expand_path(File.join(File.dirname(__FILE__), %w[.. manual contents]))
    s = prawn_manual_document.render

    hash = Digest::SHA512.hexdigest(s)

    expect(hash).to eq manual_hash
  end
end
