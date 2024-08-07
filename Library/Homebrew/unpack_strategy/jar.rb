# typed: strict
# frozen_string_literal: true

require_relative "uncompressed"

module UnpackStrategy
  # Strategy for unpacking Java archives.
  class Jar < Uncompressed
    sig { override.returns(T::Array[String]) }
    def self.extensions
      [".apk", ".jar"]
    end

    sig { override.params(path: Pathname).returns(T::Boolean) }
    def self.can_extract?(path)
      return false unless Zip.can_extract?(path)

      # Check further if the ZIP is a JAR/WAR.
      path.zipinfo.include?("META-INF/MANIFEST.MF")
    end
  end
end
