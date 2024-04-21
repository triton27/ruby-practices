MAXIMAM_COLUMNS = 3
module SimpleFormatMethods
  def output(file_and_directory_names)
    formatted_list = push_elem_to_three_lists(file_and_directory_names)
    output_list = nil_into_list(formatted_list)
    puts(output_list.transpose.map { |row| row.join(' ') })
  end

  def justify_left(list)
    max_maxlength = list.map(&:size).max
    list.map { |item| item.ljust(max_maxlength) }
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

  def nil_into_list(formatted_list)
    # 各配列の要素数を揃えるために、要素数が足りないリストにnilを入れる
    max_elem = formatted_list.max_by(&:size).size
    formatted_list.each do |elem|
      elem << nil while elem.size < max_elem
    end
  end

  module_function :output, :justify_left, :push_elem_to_three_lists, :nil_into_list
end
