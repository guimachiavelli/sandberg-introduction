require 'erb'
require 'yaml'

BUILD_DIR = File.expand_path './build'

def generate(file)
    setup
    file = File.expand_path(file)
    content = parsed_file(file)
    presentation = slides(content)

    filename = File.expand_path('./build/index.html')
    File.write(filename, presentation)
end

def setup
    Dir.mkdir(BUILD_DIR) unless Dir.exist?(BUILD_DIR)
end

def parsed_file(file)
    content = File.read file
    YAML.load content
end

def slides(content)
    tpl = File.expand_path('./template/index.html.erb')

    @output = ''
    content.each do |slide|
        slide = assembled_slide(slide)
        @output += "<div tabindex='0' class='page'>#{slide}</div>"
    end

    ERB.new(File.read(tpl)).result(binding)
end

def assembled_slide(slide)
    tag = slide['tag'] || 'p'
    html = "<#{tag}>#{slide['text']}</#{tag}>"

    if !slide['illustration'].nil?
        html += "<img src='imgs/#{slide['illustration']}' alt=''>"
    end

    html
end

generate ARGV[0]
