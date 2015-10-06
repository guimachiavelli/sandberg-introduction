require 'erb'
require 'yaml'
require 'fileutils'

BUILD_DIR = File.expand_path './build'
IMAGES_DIR = File.expand_path './content/imgs/.'

def generate(file)
    setup
    file = File.expand_path(file)
    content = parsed_file(file)
    presentation = slides(content)

    filename = File.expand_path('./build/index.html')
    File.write(filename, presentation)
    copy_images
end

def setup
    build_images = File.join(BUILD_DIR, 'imgs')
    Dir.mkdir(BUILD_DIR) unless Dir.exist?(BUILD_DIR)
    Dir.mkdir(build_images) unless Dir.exist?(build_images)
end

def copy_images
    FileUtils.cp_r(IMAGES_DIR, BUILD_DIR)
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

    if !slide['video'].nil?
        html += "<iframe width='100%' height='100%' src='#{slide['video']}' frameborder='0' allowFullScreen></iframe>"
    end

    html
end

generate ARGV[0]
