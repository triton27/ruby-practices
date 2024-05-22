#!/usr/bin/env ruby

require 'optparse'
require_relative './custom_sort'
require_relative './simple_format_methods'
require_relative './long_format_methods'

def main
  option = ARGV.getopts('a', 'r', 'l')

  entries = get_entries(option, ARGV)

  if option['l']
    LongFormatMethods.output(entries)
  else
    SimpleFormatMethods.output(entries)
  end
end

def get_entries(option, argv)
  if argv.empty?
    entries = if option['a']
                Dir.entries('.').sort { |a, b| CustomSort.custom_sort(a, b) }
              else
                entries = Dir.glob('*').sort { |a, b| CustomSort.custom_sort(a, b) }
              end
    entries.reverse! if option['r']
  else
    entries = argv
  end

  entries
end

main
