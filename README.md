# MDT - Versioned module

A module that implements versioned releases deployment flow for MDT.

## Requirements

* [mdt-core](https://github.com/Phitherek/mdt-core "mdt-core") >= 0.1.0
* Ruby (tested with 2.5.0, earlier versions down to 2.0 may also work)
* RubyGems

## Installation

`gem install mdt-versioned`

## Usage

The module is automatically loaded by `mdt`. All you need to do is to use appropriate keys in your `mdt-deploy.yml`.

## Objects defined by module

NOTE: All of the options are optional unless indicated otherwise.

### Commands

* `versioned.link_current` - creates a symlink to the current release version.
Options:
    * `current_name` - name of the link to the current release version, "current" by default.
* `versioned.link_shared` - creates symlinks to the contents of the shared directory inside the current release directory.
Options:
    * `shared_name` - name of the shared directory, "shared" by default.
* `versioned.cleanup` - deletes old releases. Options:
    * `retained_versions_count` - number of releases to retain including current release, 2 by default.

### Directory choosers

* `versioned.integer` - uses versioned subdirectories based on increasing integer (1, 2, etc.). Creates and changes to the directory. Removes the directory on failure.
Options:
    * `path` - path of the base deployment directory. Required.
    * `releases_dirname` - name of the directory that contains versioned release directories, "releases" by default.
* `versioned.timestamp` - uses versioned subdirectories based on the formatted date and time.  Creates and changes to the directory. Removes the directory on failure.
Options:
    * `path` - path of the base deployment directory. Required.
    * `releases_dirname` - name of the directory that contains versioned release directories, "releases" by default.
    * `timestamp_format` - format of the timestamp as required by Ruby Time.strftime method, "%Y%m%d%H%M%S" by default.

Both of the directory choosers set the following data in the MDT::DataStorage object:
* `versioned_base_path` - path of the base deployment directory.
* `versioned_version_id` - current version identifier.
* `versioned_releases_dirname` - name of the directory that contains versioned release directories.

## Data storage notice

All of the data in the MDT::DataStorage object set by the directory choosers has to be set for this module's commands to work properly.

## Contributing

You can contribute to the development of this MDT module by submitting an issue or pull request.

## Documentation

Generated RDoc documentation can be found [here](https://rubydoc.info/github/Phitherek/mdt-versioned "here").