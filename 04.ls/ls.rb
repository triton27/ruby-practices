#!/usr/bin/env ruby
require 'optparse'
require_relative './simple_format_methods'
require_relative './long_format_methods'

def main
  option = ARGV.getopts('a', 'r', 'l')

  file_and_directory_names = get_file_and_directory_names(option, ARGV)

  if option['l']
    LongFormatMethods.output(file_and_directory_names)
  else
    SimpleFormatMethods.output(file_and_directory_names)
  end
end

def get_file_and_directory_names(option, argv)
  if argv.empty?
    file_and_directory_names = Dir.glob('*')
    file_and_directory_names = Dir.entries('.').sort if option['a']
    if option['r']
      tmp = file_and_directory_names
      file_and_directory_names = []
      file_and_directory_names << tmp.pop while tmp.size.positive?
    end
  else
    file_and_directory_names = argv
  end

  file_and_directory_names
end

main
