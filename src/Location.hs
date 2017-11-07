module Location ( location, move ) where

import Data.JSString ( JSString, unpack )

foreign import javascript safe "var m = location.pathname.match('^/([^/]+)$'); if (m === null) { var ret = '' } else { var ret = m[1] }; ret" locationJSString :: IO JSString
foreign import javascript safe "location.href = '/' + $1" move :: String -> IO ()

location :: IO String
location = unpack <$> locationJSString
