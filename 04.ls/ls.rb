#!/usr/bin/env ruby
require 'optparse'
require_relative './ar_option_methods'
require_relative './l_option_methods'

def main
  option = ARGV.getopts('a', 'r', 'l')

  file_and_directory_names = get_file_and_directory_names(option)

  ArOptionMethods.output(file_and_directory_names) unless option['l']
  LOptionMethods.output(file_and_directory_names) if option['l']
end

def get_file_and_directory_names(option)
  file_and_directory_names = Dir.glob('*') unless option['a'] || option['r']
  file_and_directory_names = Dir.entries('.').sort if option['a']

  if option['r']
    tmp = file_and_directory_names.nil? ? Dir.glob('*') : file_and_directory_names
    file_and_directory_names = []
    file_and_directory_names << tmp.pop while tmp.size.positive?
  end

  file_and_directory_names
end

main
