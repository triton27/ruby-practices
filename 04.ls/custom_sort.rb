module CustomSort
  def custom_sort(string_a, string_b)
    # 文字列をUnicodeポイントの配列に変換
    a_code_points = string_a.codepoints
    b_code_points = string_b.codepoints

    # 各文字のUnicodeポイントに基づいて比較
    a_code_points.zip(b_code_points).each do |a_cp, b_cp|
      # 半角数字の範囲
      return -1 if (48..57).cover?(a_cp) && !(48..57).cover?(b_cp)
      return 1 if !(48..57).cover?(a_cp) && (48..57).cover?(b_cp)

      # 大文字の半角英字の範囲
      return -1 if (65..90).cover?(a_cp) && !(65..90).cover?(b_cp)
      return 1 if !(65..90).cover?(a_cp) && (65..90).cover?(b_cp)

      # 小文字の半角英字の範囲
      return -1 if (97..122).cover?(a_cp) && !(97..122).cover?(b_cp)
      return 1 if !(97..122).cover?(a_cp) && (97..122).cover?(b_cp)

      # 漢字の範囲
      return -1 if (19_968..40_959).cover?(a_cp) && !(19_968..40_959).cover?(b_cp)
      return 1 if !(19_968..40_959).cover?(a_cp) && (19_968..40_959).cover?(b_cp)

      # ひらがなの範囲
      return -1 if (12_352..12_447).cover?(a_cp) && !(12_352..12_447).cover?(b_cp)
      return 1 if !(12_352..12_447).cover?(a_cp) && (12_352..12_447).cover?(b_cp)

      # カタカナの範囲
      return -1 if (12_448..12_543).cover?(a_cp) && !(12_448..12_543).cover?(b_cp)
      return 1 if !(12_448..12_543).cover?(a_cp) && (12_448..12_543).cover?(b_cp)

      # 同じ文字の場合、次の文字へ
      next if a_cp == b_cp

      return a_cp <=> b_cp # 上記の条件に当てはまらない場合はUnicodeポイントで比較
    end

    # すべての文字が同じ場合、文字列の長さで比較
    string_a.length <=> string_b.length
  end

  module_function :custom_sort
end
