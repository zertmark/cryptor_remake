require 'aes'
require 'slop'
require 'base64'
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
  argument.string '--path', 'Path to dir or file to decrypt',required:true
  argument.string '-k','--key','Key for decryption',required:true
  argument.on '--help' do
   print (argument)
   exit()
  end
 end 
 if !File.exist?($options[:path].to_s) 
   print "\nError:invalid path"
   exit()
 end
 if $options[:key] == ""
  print ("\nError:empty key")
  exit()
 end
end
def get_key()
 $key=$options[:key].to_s
 print "\nUsing key: #{$key}"
end 
def main()
 parse()
 get_key()
 print "\nStarting..."
 search()
end 
def search()
 if File.file?($options[:path])
  print "\nDecrypting... #{path}"
  decrypt($options[:path])
  File.delete($options[:path])
 else
  Dir.chdir $options[:path]
  Dir.glob("**/**").each do |path|
   if File.file?(path)
    print "\nDecrypting: #{path}"
   #write(encrypt(File.readlines(path)),path+'.crp')
    decrypt(path)
    print "\nRemoving encrypted file"
    File.delete(path)
   else
    print "\nSkipping #{path} because it isn't a file"
   end 
  end
 end 
end
def decrypt(path)
 #encrypted_data_chunk=[]
 #File.open(path,'r').each do |line|
  #encrypted_data_chunk.push(AES.encrypt(line,$key,{:iv=>$iv})) 
  #write(AES.encrypt(line,$key,{:iv=>$iv}),path+'.crp')
 #end
 #print "Writting encrypted data to #{path+'.crp'}\n"
 #AES.encrypt(array,$key,{:iv=>$iv} 
 File.open(path).each(nil,1024) do |chunk|
  write(AES.decrypt(chunk,$key),path[0..-5])
 end
 #print "Encrypted and wrote #{path+'.crp'}"
end
def write(data,path)
 #print "\nWriting encrypted data to #{path}"
 File.open(path,'a') do |file|
  #data.each do |line|
  file.puts data.to_s 
  #end
 end 
end
main()
