#!/usr/bin/env ruby

require 'optparse'

DEFAULT_PADDING = 8

def main
  options = inspect_options(ARGV.getopts('l', 'w', 'c'))

  if $stdin.tty? # ファイル名指定の場合
    totals = calculate_files_metrics(ARGV, options)
    print_results(totals, 'total') if ARGV.length >= 2
  else # パイプで渡された場合
    totals = calculate_metrics($stdin.read, options)
    print_results(totals, nil)
  end
end

def inspect_options(options)
  if options.values.none?
    { has_lines_option: true, has_words_option: true, has_bytes_option: true }
  else
    { has_lines_option: options['l'], has_words_option: options['w'], has_bytes_option: options['c'] }
  end
end

def calculate_files_metrics(file_names, options)
  totals = [0, 0, 0] # lines, words, bytes

  file_names.each do |file_name|
    wc_results = calculate_metrics(File.read(file_name), options)
    # totals の要素数を wc_results の要素数に合わせてから update_totals に渡す
    totals = update_totals(wc_results, totals.slice(0, wc_results.length))
    print_results(wc_results, file_name)
  end
  totals
end

def calculate_metrics(content, options)
  rows  = content.count("\n")  if options[:has_lines_option]
  words = content.split.count  if options[:has_words_option]
  bytes = content.bytesize     if options[:has_bytes_option]

  [rows, words, bytes].compact
end

def update_totals(wc_results, totals)
  wc_results.each_with_index do |result, idx|
    totals[idx] += result
  end
  totals
end

# 1ファイル分、または合計の lines, bytes, words を print する
# @param file_name [String] ファイル名または "total"
def print_results(results, file_name)
  print results.map { |result| result.to_s.rjust(DEFAULT_PADDING) }.join
  print " #{file_name}\n"
end

main if __FILE__ == $PROGRAM_NAME
