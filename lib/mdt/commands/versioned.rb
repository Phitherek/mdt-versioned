require 'mdt-core'
require 'fileutils'
module MDT
  module Commands
    class Versioned < MDT::Commands::Base
      def self.key
        'versioned'
      end

      def self.subkeys
        ['link_current', 'link_shared', 'cleanup']
      end

      def execute(key, modifiers = [], options = {})
        case key
        when 'link_current'
          begin
            options['current_name'] ||= 'current'
            puts "Creating a symlink to: #{MDT::DataStorage.instance.versioned_base_path}/#{MDT::DataStorage.instance.versioned_releases_dirname}/#{MDT::DataStorage.instance.versioned_version_id} named: #{MDT::DataStorage.instance.versioned_base_path}/#{options['current_name']}"
            FileUtils.rm_f(Dir["#{MDT::DataStorage.instance.versioned_base_path}/#{options['current_name']}"])
            FileUtils.ln_s(Dir["#{MDT::DataStorage.instance.versioned_base_path}/#{MDT::DataStorage.instance.versioned_releases_dirname}/#{MDT::DataStorage.instance.versioned_version_id}"].first, "#{MDT::DataStorage.instance.versioned_base_path}/#{options['current_name']}")
            0
          rescue
            1
          end
        when 'link_shared'
          begin
            options['shared_name'] ||= 'shared'
            puts "Creating symlinks to: #{MDT::DataStorage.instance.versioned_base_path}/#{options['shared_name']}/* at: #{MDT::DataStorage.instance.versioned_base_path}/#{MDT::DataStorage.instance.versioned_releases_dirname}/#{MDT::DataStorage.instance.versioned_version_id}"
            FileUtils.ln_s(Dir["#{MDT::DataStorage.instance.versioned_base_path}/#{options['shared_name']}/*"], Dir["#{MDT::DataStorage.instance.versioned_base_path}/#{MDT::DataStorage.instance.versioned_releases_dirname}/#{MDT::DataStorage.instance.versioned_version_id}"].first)
            0
          rescue
            1
          end
        when 'cleanup'
          options['retained_versions_count'] ||= 2
          begin
            puts 'Cleaning up old releases...'
            versions = []
            Dir["#{MDT::DataStorage.instance.versioned_base_path}/#{MDT::DataStorage.instance.versioned_releases_dirname}/*"].each do |vn|
              versions << vn.split('/').last
            end
            versions.sort!
            if versions.count > options['retained_versions_count']
              versions.first(versions.count-options['retained_versions_count']).each do |v|
                FileUtils.rm_rf("#{MDT::DataStorage.instance.versioned_base_path}/#{MDT::DataStorage.instance.versioned_releases_dirname}/#{v}")
              end
            end
            0
          rescue
            1
          end
        end
      end
    end
  end
end