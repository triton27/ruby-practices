# frozen_string_literal: true

module CustomSort
  CHAR_CODEPOINTS_RANGE = [
    '0'.codepoints.first..'9'.codepoints.first, # 半角数字の範囲
    'A'.codepoints.first..'Z'.codepoints.first, # 大文字の半角英字の範囲
    'a'.codepoints.first..'z'.codepoints.first, # 小文字の半角英字の範囲
    '一'.codepoints.first..'鿿'.codepoints.first, # 漢字の範囲
    'あ'.codepoints.first..'ん'.codepoints.first, # ひらがなの範囲
    'ア'.codepoints.first..'ン'.codepoints.first  # カタカナの範囲
  ].freeze

  def custom_sort(string_a, string_b)
    # 文字列をUnicodeポイントの配列に変換
    a_code_points = string_a.codepoints
    b_code_points = string_b.codepoints

    # 各文字のUnicodeポイントに基づいて比較
    a_code_points.zip(b_code_points).each do |a_cp, b_cp|
      # 同じ文字の場合、次の文字へ
      next if a_cp == b_cp

      CHAR_CODEPOINTS_RANGE.each do |range|
        result = test(range, a_cp, b_cp)
        # puts range, a_cp, b_cp, result
        return result unless result.zero?
      end

      return a_cp <=> b_cp # 上記の条件に当てはまらない場合はUnicodeポイントで比較
    end

    # すべての文字が同じ場合、文字列の長さで比較
    string_a.length <=> string_b.length
  end

  def test(range, a_cp, b_cp)
    return -1 if range.cover?(a_cp) && !range.cover?(b_cp)
    return 1 if !range.cover?(a_cp) && range.cover?(b_cp)

    0
  end

  module_function :custom_sort, :test
end
