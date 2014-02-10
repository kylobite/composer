#!/usr/bin/env ruby

def compose dst, data=nil, output = true
    return nil if dst.empty?

    value = nil

    IO.popen(dst, "r+") do |pipe|
        pipe.puts(data) unless data.nil?
        pipe.close_write
        value = pipe.read
    end

    return value if output
end

def parse file
    return nil if file.empty?

    dir     = File.expand_path File.dirname __FILE__
    content = File.open("#{dir}/#{file}") {|f| f.read}
    lines   = content.split("\n")
    order   = lines.map do |x| 
        x.scan(/(.*):(.*)\[(\d),(\d)\]/).flatten
    end

    cmd, file, data, output = [[],[],[],[]]

    order.each do |d|
        cmd << d[0]
        file << d[1]
        data << d[2]
        output << d[3]
    end

    data.inspect

    return [cmd, file, data, output]
end

def assign vals
    return nil if vals.empty? or vals.size != 4

    num     = vals[0].size
    list  = Array.new

    (0...num).each do |i|
        combine = [vals[0][i], vals[1][i]]
        
        launch  = vals[0][i] == "./" ? (combine * "") : (combine * " ")
        data    = vals[2][i] == "1" ? list[i - 1] : nil
        output  = vals[3][i] == "1" ? true : false
        list << Proc.new { compose( launch, data, output ) }
    end

    return list
end

def execute list
    return nil if list.empty?

    list.reverse!
    num = list.size - 1

    (0..num).each do |i|
        cache = list[i].call
        puts cache if i == num
    end
end
