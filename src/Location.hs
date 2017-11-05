module Location ( location ) where

import Data.JSString ( JSString, unpack )

foreign import javascript safe "location.href.match('[^?]+$')[0] || ''" locationJSString :: IO JSString

-- for SPA
-- foreign import javascript safe "location.pathname.match('[^/]+$')[0] || ''" locationJSString :: IO JSString

location :: IO String
location = unpack <$> locationJSString