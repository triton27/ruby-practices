class Stat
  STAT = [
    NLINK = :nlink,
    OWNER = :owner,
    GROUP = :group,
    SIZE = :size
  ].freeze

  def get_maxlength_hash(files_stat)
    stat_hash = {}
    STAT.each do |stat|
      stat_hash[stat] = get_maxlength(stat, files_stat)
    end
    stat_hash
  end

  def get_maxlength(stat, files_stat)
    case stat
    when NLINK then files_stat.map { |fs| fs.nlink.to_s.length }.max
    when OWNER then files_stat.map { |fs| Etc.getpwuid(fs.uid).name.length }.max
    when GROUP then files_stat.map { |fs| Etc.getgrgid(fs.gid).name.length }.max
    when SIZE  then files_stat.map { |fs| fs.size.to_s.length }.max
    else 'Unknown stat'
    end
  end
end

def get_blocks(files_stat)
  blocks = 0
  files_stat.each do |stat|
    blocks += stat.blocks
  end
  blocks
end

def get_mode(file_stat)
  file_mode = ''
  permit_as_num = file_stat.mode.to_s(8)

  get_permission(permit_as_num, file_mode)
  get_special_permission(permit_as_num, file_mode)
  get_file_type(permit_as_num, file_mode)

  file_mode
end

# ファイルの種類を表す数値が可変（１~２桁）なので、
# 末尾から順に数値を変換していき、残った１~２桁の数値をファイルタイプとして変換する
def get_permission(permit_as_num, file_mode)
  3.times do
    case permit_as_num.slice!(-1)
    when '7' then file_mode.prepend 'rwx'
    when '6' then file_mode.prepend 'rw-'
    when '5' then file_mode.prepend 'r-x'
    when '4' then file_mode.prepend 'r--'
    when '3' then file_mode.prepend '-wx'
    when '2' then file_mode.prepend '-w-'
    when '1' then file_mode.prepend '--x'
    else file_mode.prepend '---'
    end
  end
  file_mode
end

def get_special_permission(permit_as_num, file_mode)
  case permit_as_num.slice!(-1)
  when '4' then file_mode.prepend 't'
  when '2' then file_mode.prepend 's'
  when '1' then file_mode.prepend 's'
  end
  file_mode
end

def get_file_type(permit_as_num, file_mode)
  case permit_as_num
  when '1'  then file_mode.prepend 'p'
  when '2'  then file_mode.prepend 'c'
  when '4'  then file_mode.prepend 'd'
  when '6'  then file_mode.prepend 'b'
  when '10' then file_mode.prepend '-'
  when '12' then file_mode.prepend 'l'
  when '14' then file_mode.prepend 's'
  end
  file_mode
end

def get_mtime(file_stat)
  file_mmon = file_stat.mtime.mon.to_s
  file_mday = file_stat.mtime.day.to_s
  file_myear = file_stat.mtime.year.to_s
  file_mhour = format('%02d', file_stat.mtime.hour)
  file_mmin = format('%02d', file_stat.mtime.min)

  file_mtime =
    "#{file_mmon.rjust(2)} #{file_mday.rjust(2)}"

  file_mtime += if Date.today.year > file_stat.mtime.year
                  " #{file_myear}"
                else
                  " #{file_mhour}:#{file_mmin}"
                end

  file_mtime
end
