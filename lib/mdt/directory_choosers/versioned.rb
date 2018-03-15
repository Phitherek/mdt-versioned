require 'mdt-core'
require 'fileutils'
module MDT
  # A module containing all directory choosers
  module DirectoryChoosers
    # A class that implements directory choosers for versioned releases flow
    class Versioned < MDT::DirectoryChoosers::Base
      # A method that defines a key for command modifiers class.
      # Returns:
      # * "versioned"
      def self.key
        'versioned'
      end

      # A method that defines keys for available command modifiers.
      # Returns:
      # * +["timestamp", "integer"]+
      def self.subkeys
        ['timestamp', 'integer']
      end

      # A method that defines how to create a deploy directory with directory choosers.
      # Arguments:
      # * +key+ - a key identifier of a particular directory chooser
      # * +options+ - options for directory chooser as a Hash
      # Returns:
      # * Exit code for directory chooser +key+
      # More information:
      # * See README.md for detailed description of directory choosers
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
            1
          end
        when 'integer'
          begin
            if Dir.exist?("#{options['path']}/#{options['releases_dirname']}")
              previous_versions = []
              Dir["#{options['path']}/#{options['releases_dirname']}/*"].each do |vd|
                previous_versions << vd.split('/').last
              end
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
            1
          end
        end
      end

      # A method that defines how to change working directory to a deploy directory with directory choosers.
      # Arguments:
      # * +key+ - a key identifier of a particular directory chooser
      # * +options+ - options for directory chooser as a Hash
      # Returns:
      # * Exit code for directory chooser +key+
      # More information:
      # * See README.md for detailed description of directory choosers
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

      # A method that defines how to remove a deploy directory with directory choosers.
      # Arguments:
      # * +key+ - a key identifier of a particular directory chooser
      # * +options+ - options for directory chooser as a Hash
      # Returns:
      # * Exit code for directory chooser +key+
      # More information:
      # * See README.md for detailed description of directory choosers
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