MAXIMAM_COLUMNS = 3
module SimpleFormatMethods
  def output(file_and_directory_names)
    formatted_list = push_elem_to_three_lists(file_and_directory_names)
    output_list = pad_with_nil(formatted_list)
    puts(output_list.transpose.map { |row| row.join(' ') })
  end

  # ターミナルの幅に関わらず横に最大３列を維持するため
  # ３つの配列に要素を詰める
  def push_elem_to_three_lists(file_and_directory_names)
    tmp = []
    file_and_directory_names.each_slice(file_and_directory_names.size / MAXIMAM_COLUMNS + 1) do |list|
      tmp << justify_left(list)
    end
    tmp
  end

  def justify_left(strings)
    widths = calculate_widths(strings)
    max_width = widths.max
    justified_words = []
    widths.each_with_index do |width, idx|
      justified_words << strings[idx] + ' ' * (max_width - width)
    end
    justified_words
  end

  def calculate_widths(strings)
    strings.map { |string| calculate_width(string) }
  end

  def calculate_width(string)
    string.each_char.reduce(0) do |sum, char|
      sum + (zenkaku?(char) ? 2 : 1)
    end
  end

  def zenkaku?(char)
    byte_size = char.encode('UTF-8').bytesize
    # バイト数が1なら半角、それ以外は全角と判定
    byte_size > 1
  end

  def pad_with_nil(strings)
    # 各配列の要素数を揃えるために、要素数が足りないリストにnilを入れる
    max_length = strings.map(&:size).max
    strings.map { |string| string + [nil] * (max_length - string.size) }
  end

  module_function :output, :justify_left, :push_elem_to_three_lists,
                  :pad_with_nil, :calculate_widths, :calculate_width, :zenkaku?
end
