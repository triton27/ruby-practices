#!/usr/bin/env ruby

require 'optparse'

def main
  option = ARGV.getopts('a', 'r')

  files_and_dirs_name = Dir.glob('*') unless option['a'] || option['r']
  files_and_dirs_name = Dir.entries('.').sort if option['a']
  if option['r']
    tmp = files_and_dirs_name.nil? ? Dir.glob('*') : files_and_dirs_name
    files_and_dirs_name = []
    files_and_dirs_name << tmp.pop while tmp.size.positive?
  end

  formatted_list = push_elem_to_three_lists(files_and_dirs_name)
  output_list = def_nil_to_list(formatted_list)

  puts(output_list.transpose.map { |row| row.join(' ') })
end

def adjust_with_margin(list)
  max_chars = list.map(&:size).max
  list.map { |item| item.ljust(max_chars) }
end

# ターミナルの幅に関わらず横に最大３列を維持するため
# ３つの配列に要素を詰める
MAXIMAM_COLUMNS = 3
def push_elem_to_three_lists(files_and_dirs_name)
  tmp = []
  files_and_dirs_name.each_slice(files_and_dirs_name.size / MAXIMAM_COLUMNS + 1) do |list|
    tmp << adjust_with_margin(list)
  end
  tmp
end

def def_nil_to_list(formatted_list)
  # 各配列の要素数を揃えるために、要素数が足りないリストにnilを入れる
  max_elem = formatted_list.max_by(&:size).size
  formatted_list.each do |elem|
    elem << nil while elem.size < max_elem
  end
end

main
