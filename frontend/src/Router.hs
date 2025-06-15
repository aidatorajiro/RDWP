{-# LANGUAGE OverloadedStrings, FlexibleContexts #-}

module Router (parseLocationPath) where

import qualified Data.Text as T
import Text.Parsec
import Reflex.Dom
import qualified Index
import qualified FakeIndex
import qualified Mensae
import qualified Error404
import qualified Nami
import qualified Nazo
import qualified Mn1
import qualified Ars
import qualified IClub
import qualified Harituke
import qualified Ubana
import qualified Onsen
import qualified Logg
import qualified Source
import qualified Dott
import qualified Hikoki
import qualified Shishi

-- | parse URL Location Path
parseLocationPath :: MonadWidget t m => Parsec T.Text () (m (Event t T.Text))
parseLocationPath =
  let -- ex. "/testes"
      l path widget = string path >> eof >> return widget
      -- ex. "/testes0", "/testes1", "/testes2", ...
      ln path widget = string path >> fmap (widget . read) (many1 digit)
      -- ex. "/testes_a", "/testes_ksk", "/testes_tska", ...
      ls path widget = string path >> fmap widget (many anyChar)
  in choice $ map try [
      l "/index" Index.page,
      l "/" FakeIndex.page,
      l "" FakeIndex.page,
      l "/mensae" Mensae.page,
      l "/nmnmnmnmn" Nami.page,
      l "/nazo" Nazo.page,
      l "/worry" Mn1.page,
      l "/skate" Mn1.page,
      ln "/ars" Ars.page,
      ln "/onsen" Onsen.page,
      l "/iclub" IClub.page,
      l "/harituke" Harituke.page,
      l "/nannkahenndayo" Ubana.page,
      l "/logg" Logg.page,
      ls "/cf1" Source.page,
      ls "/dott" Dott.page,
      l "/hikoki" Hikoki.page,
      ln "/shishi" Shishi.page
    ]
