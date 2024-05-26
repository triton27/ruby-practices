#!/usr/bin/env ruby

require 'optparse'

def main
  total_rows, total_words, total_bytes, files_len, options = process_files

  # 引数にファイルを2件以上指定した場合、各要素の合計値を出力する
  print_totals(total_rows, total_words, total_bytes, options) if files_len > 1
end

def process_files
  total_rows  = 0
  total_words = 0
  total_bytes = 0

  options, files = parse_input
  files_len = files.length

  files.each do |file|
    file_content = read_file_content(file)
    rows, words, bytes = calculate_file_metrics(file_content, options)
    if files_len > 1
      if options.values.none?
        total_rows  += rows
        total_words += words
        total_bytes += bytes
      else
        options[:has_lines_option] ? total_rows  += rows  : rows  == nil
        options[:has_words_option] ? total_words += words : words == nil
        options[:has_bytes_option] ? total_bytes += bytes : bytes == nil
      end
    end

    print_files(rows, words, bytes, file, options)
  end

  [total_rows, total_words, total_bytes, files_len, options]
end

def parse_input
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

def read_file_content(file)
  File.read(file)
rescue Errno::ENOENT
  puts "Error: File '#{file}' not found."
rescue Errno::EACCES
  puts "Error: Permission denied for file '#{file}'."
rescue StandardError => e
  puts "Error: #{e.message}"
end

def calculate_file_metrics(file_content, options)
  if options.values.none?
    rows  = file_content.count("\n")
    words = count_words(file_content)
    bytes = file_content.bytesize
  else
    rows  = file_content.count("\n")  if options[:has_lines_option]
    words = count_words(file_content) if options[:has_words_option]
    bytes = file_content.bytesize     if options[:has_bytes_option]
  end

  [rows, words, bytes]
end

def count_words(text)
  words = text.scan(/\b\w+\b/)
  words.count
end

def custom_padding(options)
  padding_lines = 0
  words_padding = 0
  padding_bytes = 0

  options[:has_lines_option] ? padding_lines = 8 : padding_lines
  options[:has_words_option] ? words_padding = 7 : words_padding
  options[:has_bytes_option] ? padding_bytes = 7 : padding_bytes

  [padding_lines, words_padding, padding_bytes]
end

def print_files(rows, words, bytes, file, options)
  padding_lines, words_padding, padding_bytes = custom_padding(options)

  puts "#{rows.to_s.rjust(padding_lines)} #{words.to_s.rjust(words_padding)} #{bytes.to_s.rjust(padding_bytes)} #{file}"
end

def print_totals(total_rows, total_words, total_bytes, options)
  total_rows  = nil if total_rows.zero?
  total_words = nil if total_words.zero?
  total_bytes = nil if total_bytes.zero?

  padding_lines, words_padding, padding_bytes = custom_padding(options)

  puts "#{total_rows.to_s.rjust(padding_lines)} #{total_words.to_s.rjust(words_padding)} #{total_bytes.to_s.rjust(padding_bytes)} total"
end

main
