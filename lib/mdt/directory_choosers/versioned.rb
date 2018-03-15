require 'mdt-core'
require 'fileutils'
module MDT
  module DirectoryChoosers
    class Versioned < MDT::DirectoryChoosers::Base
      def self.key
        'versioned'
      end

      def self.subkeys
        ['timestamp', 'integer']
      end

      def mkdir(key, options = {})
        return 1 unless options['path']
        options['releases_dirname'] ||= 'releases'
        case key
        when 'timestamp'
          begin
            options['timestamp_format'] ||= '%Y%m%d%H%M%S'
            MDT::DataStorage.instance.versioned_base_path = options['path']
            MDT::DataStorage.instance.versioned_version_id = Time.now.strftime(options['timestamp_format'])
            MDT::DataStorage.instance.versioned_releases_dirname = options['releases_dirname']
            puts "Creating directory: #{MDT::DataStorage.instance.versioned_base_path}/#{MDT::DataStorage.instance.versioned_releases_dirname}/#{MDT::DataStorage.instance.versioned_version_id}"
            FileUtils.mkdir_p("#{MDT::DataStorage.instance.versioned_base_path}/#{MDT::DataStorage.instance.versioned_releases_dirname}/#{MDT::DataStorage.instance.versioned_version_id}")
            0
          rescue => e
            puts e.to_s
            puts e.backtrace
            1
          end
        when 'integer'
          begin
            if Dir.exist?("#{options['path']}/#{options['releases_dirname']}")
              puts 'exists'
              previous_versions = []
              Dir["#{options['path']}/#{options['releases_dirname']}/*"].each do |vd|
                previous_versions << vd.split('/').last
              end
              puts previous_versions
              previous_versions.sort!
              MDT::DataStorage.instance.versioned_version_id = (previous_versions.last.to_i + 1).to_s
            else
              MDT::DataStorage.instance.versioned_version_id = 1.to_s
            end
            MDT::DataStorage.instance.versioned_base_path = options['path']
            MDT::DataStorage.instance.versioned_releases_dirname = options['releases_dirname']
            puts "Creating directory: #{MDT::DataStorage.instance.versioned_base_path}/#{MDT::DataStorage.instance.versioned_releases_dirname}/#{MDT::DataStorage.instance.versioned_version_id}"
            FileUtils.mkdir_p("#{MDT::DataStorage.instance.versioned_base_path}/#{MDT::DataStorage.instance.versioned_releases_dirname}/#{MDT::DataStorage.instance.versioned_version_id}")
            0
          rescue => e
            puts e.to_s
            puts e.backtrace
            1
          end
        end
      end

      def cd(key, options = {})
        return 1 unless self.class.subkeys.include?(key)
        begin
          puts "Changing working directory to: #{MDT::DataStorage.instance.versioned_base_path}/#{MDT::DataStorage.instance.versioned_releases_dirname}/#{MDT::DataStorage.instance.versioned_version_id}"
          FileUtils.cd(Dir["#{MDT::DataStorage.instance.versioned_base_path}/#{MDT::DataStorage.instance.versioned_releases_dirname}/#{MDT::DataStorage.instance.versioned_version_id}"].first)
          0
        rescue
          1
        end
      end

      def rm(key, options = {})
        return 1 unless self.class.subkeys.include?(key)
        begin
          puts "Removing directory: #{MDT::DataStorage.instance.versioned_base_path}/#{MDT::DataStorage.instance.versioned_releases_dirname}/#{MDT::DataStorage.instance.versioned_version_id}"
          FileUtils.rm_rf(Dir["#{MDT::DataStorage.instance.versioned_base_path}/#{MDT::DataStorage.instance.versioned_releases_dirname}/#{MDT::DataStorage.instance.versioned_version_id}"].first)
          0
        rescue
          1
        end
      end
    end
  end
end