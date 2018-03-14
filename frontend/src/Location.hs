{-# LANGUAGE CPP #-}
module Location ( location, move, asset ) where

#ifdef ghcjs_HOST_OS
import Data.JSString ( JSString, unpack, pack )

foreign import javascript safe "var m = location.pathname.match('^/([^/]+)$'); if (m === null) { $r = '' } else { $r = m[1] };" locationJSString :: IO JSString
foreign import javascript safe "location.href = '/' + $1" moveJSString :: JSString -> IO ()

-- jump to specific location
move :: String -> IO ()
move = moveJSString . pack

-- get current location
location :: IO String
location = unpack <$> locationJSString

#else
move :: String -> IO ()
move = const $ return ()

location :: IO String
location = return ""
#endif

-- get asset path
asset :: String -> String
asset = ("/assets/" ++)