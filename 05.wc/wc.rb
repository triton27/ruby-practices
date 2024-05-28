#!/usr/bin/env ruby

require 'optparse'

def main
  options, files = parse_entries

  if $stdin.tty?
    total_rows, total_words, total_bytes = calculate_from_source(files, options, true)
    print_totals(total_rows, total_words, total_bytes, options, true) if files.length > 1
  else
    total_rows, total_words, total_bytes = calculate_from_source($stdin.to_a, options, false)
    print_totals(total_rows, total_words, total_bytes, options, false)
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

def calculate_from_source(inputs, options, is_file)
  total_rows = 0
  total_words = 0
  total_bytes = 0

  inputs.each do |input|
    if is_file
      file_content = File.read(input)
      rows, words, bytes = calculate_metrics(file_content, options)
      print_files(rows, words, bytes, input, options)
    else
      rows, words, bytes = calculate_metrics(input, options)
    end
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
  default_padding_lines = 8
  default_padding_words = 8
  default_padding_bytes = 8

  if options.empty? || options.values.none?
    [default_padding_lines, default_padding_words, default_padding_bytes]
  else
    padding_lines = options[:has_lines_option] ? default_padding_lines : 0
    padding_words = options[:has_words_option] ? default_padding_words : 0
    padding_bytes = options[:has_bytes_option] ? default_padding_bytes : 0

    [padding_lines, padding_words, padding_bytes]
  end
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
