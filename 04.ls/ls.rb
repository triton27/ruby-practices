#!/usr/bin/env ruby
# frozen_string_literal: true

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
    entries = Dir.glob('*').sort { |a, b| CustomSort.custom_sort(a, b) }
    entries = Dir.entries('.').sort { |a, b| CustomSort.custom_sort(a, b) } if option['a']
    if option['r']
      tmp = entries
      entries = []
      entries << tmp.pop while tmp.size.positive?
    end
  else
    entries = argv
  end

  entries
end

main
