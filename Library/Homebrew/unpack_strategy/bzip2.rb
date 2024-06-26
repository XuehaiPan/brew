# typed: true
# frozen_string_literal: true

require "utils/copy"

module UnpackStrategy
  # Strategy for unpacking bzip2 archives.
  class Bzip2
    include UnpackStrategy

    sig { returns(T::Array[String]) }
    def self.extensions
      [".bz2"]
    end

    def self.can_extract?(path)
      path.magic_number.match?(/\ABZh/n)
    end

    private

    sig { override.params(unpack_dir: Pathname, basename: Pathname, verbose: T::Boolean).returns(T.untyped) }
    def extract_to_dir(unpack_dir, basename:, verbose:)
      Utils::Copy.with_attributes path, unpack_dir/basename
      quiet_flags = verbose ? [] : ["-q"]
      system_command! "bunzip2",
                      args:    [*quiet_flags, unpack_dir/basename],
                      verbose:
    end
  end
end
