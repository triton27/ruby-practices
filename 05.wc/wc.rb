#!/usr/bin/env ruby

require 'optparse'

def main
  if $stdin.tty?
    options, files = parse_entries
    total_rows, total_words, total_bytes = calculate_from_files(files, options)
    print_totals(total_rows, total_words, total_bytes, options, true) if files.length > 1
  else
    total_rows, total_words, total_bytes = calculate_from_stdin
    print_totals(total_rows, total_words, total_bytes, [], false)
  end
end

def parse_entries
  options = inspect_options(ARGV.select { |x| x.start_with?('-') })
  files = ARGV.reject { |arg| arg.start_with?('-') }

  [options, files]
end

def inspect_options(options)
  has_lines_option = options.any? { |option| option.delete('-').include?('l') }
  has_words_option = options.any? { |option| option.delete('-').include?('w') }
  has_bytes_option = options.any? { |option| option.delete('-').include?('c') }

  { has_lines_option:, has_words_option:, has_bytes_option: }
end

def calculate_from_files(files, options)
  total_rows = 0
  total_words = 0
  total_bytes = 0

  files.each do |file|
    file_content = read_file_content(file)
    rows, words, bytes = calculate_metrics(file_content, options)
    total_rows, total_words, total_bytes = update_totals(rows, words, bytes, total_rows, total_words, total_bytes)
    print_files(rows, words, bytes, file, options)
  end

  [total_rows, total_words, total_bytes]
end

def read_file_content(file)
  File.read(file)
rescue Errno::ENOENT
  puts "Error: File '#{file}' not found."
rescue Errno::EACCES
  puts "Error: Permission denied for file '#{file}'."
rescue StandardError => e
  puts "Error: #{e.message}"
end

def calculate_from_stdin
  total_rows = 0
  total_words = 0
  total_bytes = 0

  $stdin.to_a.each do |input|
    rows, words, bytes = calculate_metrics(input, [])
    total_rows, total_words, total_bytes = update_totals(rows, words, bytes, total_rows, total_words, total_bytes)
  end

  [total_rows, total_words, total_bytes]
end

def calculate_metrics(content, options)
  if options.empty? || options.values.none?
    rows  = content.count("\n")
    words = content.split.count
    bytes = content.bytesize
  else
    rows  = content.count("\n")  if options[:has_lines_option]
    words = content.split.count  if options[:has_words_option]
    bytes = content.bytesize     if options[:has_bytes_option]
  end

  [rows, words, bytes]
end

def update_totals(rows, words, bytes, total_rows, total_words, total_bytes)
  total_rows += rows if rows
  total_words += words if words
  total_bytes += bytes if bytes

  [total_rows, total_words, total_bytes]
end

def custom_padding(options)
  padding_lines = 8
  padding_words = 8
  padding_bytes = 8

  unless options.empty? || options.values.none?
    padding_lines = options[:has_lines_option] ? padding_lines : 0
    padding_words = options[:has_words_option] ? padding_words : 0
    padding_bytes = options[:has_bytes_option] ? padding_bytes : 0
  end

  [padding_lines, padding_words, padding_bytes]
end

def print_files(rows, words, bytes, file, options)
  padding_lines, padding_words, padding_bytes = custom_padding(options)
  puts "#{rows.to_s.rjust(padding_lines)}#{words.to_s.rjust(padding_words)}#{bytes.to_s.rjust(padding_bytes)} #{file}"
end

def print_totals(total_rows, total_words, total_bytes, options, should_output_total)
  total_rows  = nil if total_rows.zero?
  total_words = nil if total_words.zero?
  total_bytes = nil if total_bytes.zero?

  padding_lines, padding_words, padding_bytes = custom_padding(options)
  total = should_output_total ? 'total' : ''

  puts "#{total_rows.to_s.rjust(padding_lines)}#{total_words.to_s.rjust(padding_words)}#{total_bytes.to_s.rjust(padding_bytes)} #{total}"
end

main if __FILE__ == $PROGRAM_NAME
