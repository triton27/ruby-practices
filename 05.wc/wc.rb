#!/usr/bin/env ruby

def main
  ARGV.each do |file|
    file_content = File.read(file)

    rows = file_content.count("\n")
    words = count_words(file_content)
    bytes = file_content.bytesize

    puts "#{rows.to_s.rjust(8)} #{words.to_s.rjust(7)} #{bytes.to_s.rjust(7)} #{file}"
  rescue Errno::ENOENT
    puts "Error: File '#{file}' not found."
  rescue Errno::EACCES
    puts "Error: Permission denied for file '#{file}'."
  rescue StandardError => e
    puts "Error: #{e.message}"
  end
end

def count_words(text)
  words = text.scan(/\b\w+\b/)
  words.count
end

main
