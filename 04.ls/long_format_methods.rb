require 'date'
require 'etc'
require_relative './stat'

SPACE = ' '.freeze

module LongFormatMethods
  def output(file_and_directory_names)
    files_stat = file_and_directory_names.map { |name| File::Stat.new(name) }

    stat_obj = Stat.new
    stat_hash = stat_obj.get_maxlength_hash(files_stat)

    puts "total#{SPACE}#{get_blocks(files_stat)}"
    display_long_format(file_and_directory_names.shift, files_stat.shift, stat_hash) while files_stat.size.positive?
  end

  def display_long_format(file_name, file_stat, stat_hash)
    file_mode = get_mode(file_stat)
    file_hardlink =
      file_stat.nlink.to_s.rjust(stat_hash[:nlink])
    file_owner =
      Etc.getpwuid(file_stat.uid).name.to_s.rjust(stat_hash[:owner])
    file_group =
      Etc.getgrgid(file_stat.gid).name.to_s.rjust(stat_hash[:group])
    file_size = file_stat.size.to_s.rjust(stat_hash[:size])
    file_mtime = get_mtime(file_stat)

    printf file_mode
    printf "#{SPACE * 2}#{file_hardlink}"
    printf "#{SPACE}#{file_owner}"
    printf "#{SPACE * 2}#{file_group}"
    printf "#{SPACE * 2}#{file_size}"
    printf "#{SPACE}#{file_mtime}"
    printf "#{SPACE}#{file_name}"
    printf "\n"
  end

  module_function :output, :display_long_format
end
