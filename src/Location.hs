module Location ( location, move, asset ) where

import Data.JSString ( JSString, unpack, pack )

foreign import javascript safe "var m = location.pathname.match('^/([^/]+)$'); if (m === null) { $r = '' } else { $r = m[1] };" locationJSString :: IO JSString
foreign import javascript safe "location.href = '/' + $1" moveJSString :: JSString -> IO ()

-- jump to specific location
move :: String -> IO ()
move = moveJSString . pack

-- get current location
location :: IO String
location = unpack <$> locationJSString

-- get asset path
asset :: String -> String
asset = ("/assets/" ++)