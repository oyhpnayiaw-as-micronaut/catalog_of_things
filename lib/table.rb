module Table
  class ::Array
    def to_table(header: true)
      column_sizes = reduce([]) do |lengths, row|
        row.each_with_index.map { |iterand, index| [lengths[index] || 0, iterand.to_s.length].max }
      end
      head = "+#{column_sizes.map { |column_size| '-' * (column_size + 2) }.join('+')}+"
      puts head

      to_print = clone
      if header == true
        header = to_print.shift
        print_table_data_row(column_sizes, header)
        puts head
      end
      to_print.each { |row| print_table_data_row(column_sizes, row) }
      puts head
    end

    private

    def print_table_data_row(column_sizes, arr)
      row = arr.fill(nil, arr.size..(column_sizes.size - 1))
      row = row.each_with_index.map { |v, i| v.to_s + (' ' * (column_sizes[i] - v.to_s.length)) }
      puts "| #{row.join(' | ')} |"
    end
  end
end
