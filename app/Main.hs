module Main where

import Lib
import System.Process
import System.Directory
type Path = String
type History=[Path]

currentDate :: IO String
currentDate = readProcess "date" ["+%Y%m%d-%H%M%S"] "" >>=return.head.lines

addPicture :: Path -> IO ()
addPicture path = do
  timeStamp <- currentDate
  readProcess "/bin/bash" ["-c", "curl -s 'http://cams.pladi.bg/eho.jpg' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:65.0) Gecko/20100101 Firefox/65.0' -H 'Accept: image/webp,*/*' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Referer: https://www.webcams.bg/' -H 'Connection: keep-alive' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' > ~/Pictures/"++path++"/eho"++timeStamp++".jpg"] ""
  return ()

loadFiles:: Path -> IO [Path]
loadFiles path = readProcess "ls" ["/home/oem/Pictures/"++path, "-1","--sort=time"] "" >>= return.lines

playFile:: Path->IO()
playFile src = do
  readProcess "/bin/bash" ["-c", "cp ~/Pictures/eho/"++src++" ~/Pictures/eho.jpg; sleep 1"] ""
  return ()

main :: IO ()
main = addPicture "eho" >> loadFiles "eho" >>= (\l -> mapM_ playFile (reverse $ take 20 l))
