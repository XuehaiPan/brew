# typed: strict
# frozen_string_literal: true

module Cask
  class Reinstall
    sig {
      params(
        casks: ::Cask::Cask, verbose: T::Boolean, force: T::Boolean, skip_cask_deps: T::Boolean, binaries: T::Boolean,
        require_sha: T::Boolean, quarantine: T::Boolean, zap: T::Boolean
      ).void
    }
    def self.reinstall_casks(
      *casks,
      verbose: false,
      force: false,
      skip_cask_deps: false,
      binaries: false,
      require_sha: false,
      quarantine: false,
      zap: false
    )
      require "cask/installer"

      quarantine = true if quarantine.nil?

      download_queue = Homebrew::DownloadQueue.new(pour: true) if Homebrew::EnvConfig.download_concurrency > 1
      cask_installers = casks.map do |cask|
        Installer.new(cask, binaries:, verbose:, force:, skip_cask_deps:, require_sha:, reinstall: true,
                      quarantine:, zap:, download_queue:)
      end

      if download_queue
        oh1 "Fetching downloads for: #{casks.map { |cask| Formatter.identifier(cask.full_name) }.to_sentence}",
            truncate: false
        cask_installers.each(&:enqueue_downloads)
        download_queue.fetch
      end

      cask_installers.each(&:install)
    end
  end
end
