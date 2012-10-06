path = require 'path'
fs = require 'fs'
debug = require '../debug'

# this class is absurd. its purpose is to resolve and
# hold on to all the file paths and contents necessary to
# compile the file. this looks messy, but it's what keeps
# the actual compilers clean

module.exports = class CompileHelper

  constructor: (@file, @options, @name) ->

    @current_directory = path.normalize process.cwd()

    # figure out what type of file will be exported
    if @options.file_types.html.indexOf(@name) > -1
      @target_extension = 'html'
      base_folder = @options.folder_config.views
      @layout_path = path.join @current_directory, base_folder, @options.layouts.default # check for customs
      @layout_contents = fs.readFileSync @layout_path, 'utf8'
    else if @options.file_types.css.indexOf(@name) > -1
      @target_extension = 'css'
      base_folder = @options.folder_config.assets
    else if @options.file_types.js.indexOf(@name) > -1
      @target_extension = 'js'
      base_folder = @options.folder_config.assets
    else
      throw "unsupported file extension: .#{@name}"

    @file_path = path.join @current_directory, base_folder, @file
    @file_contents = fs.readFileSync @file_path, 'utf8'
    @export_path = path.join @current_directory, 'public', path.dirname(@file), "#{path.basename @file, path.extname(@file)}.#{@target_extension}"
    

  write: (write_content)->
    fs.writeFileSync @export_path, write_content
    debug.log "compiled #{path.basename(@file)}"
