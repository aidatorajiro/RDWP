{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE RecursiveDo #-}

module Logg ( page ) where

import Reflex.Dom
import qualified Data.Text as T
import Elements
import Data.Monoid ((<>))
import Text.RawString.QQ
import Data.Char (ord)
import qualified Data.Map as M

css :: T.Text
css = [r|
body {
    background: #1d9cc6;
}
span {
    width:32px;
    height:32px;
    padding: 8px;
    text-align: center;
    line-height: 32px;
    display: inline-block;
    opacity: 0.3;
}
span.c1 {
    background: #a215c1;
}
span.c2 {
    background: #15c1c1;
}
span.c3 {
    background: #5a8453;
}
span.c4 {
    background: #ea2a5d;
}
span.c5 {
    background: #eab72a;
}
span.c6 {
    background: #ea572a;
}
span.c7 {
    background: #2d2425;
}
span.c8 {
    background: #142d11;
}
span.c9 {
    background: #0a0e33;
}
span.c0 {
    background: #64bc42;
}
img {
    padding: 8px;
    cursor: pointer;
}
|]

page :: MonadWidget t m => m (Event t T.Text)
page = do
    style css
    
    (playbtn, _) <- assetImg' "pl.png" (return ())
    loggcut <- fmap (\n -> T.lines $ T.take 1000 $ T.drop (n*1000) logg) <$> count (domEvent Click playbtn)

    dyn $ mapM_ (\x -> elClass "p" "line" $ do
            T.foldl (\a c -> do
                    let m = T.pack $ show $ ord c `mod` 10
                    a
                    elClass "span" ("c" <> m) (text m)
                ) (return ()) x
        ) <$> loggcut

    return never

-- log ga bakete detekuru
logg :: T.Text
logg = [r|
commit 64b563b321e6098b1c519fa88488edc5d0a65588
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 25 11:37:08 2021 +0900

    add initial page function for GHC-built appliction

commit bbc120daf4fb99a84026153656ee17062162a9e9
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 25 11:36:25 2021 +0900

    update rebuild.sh

commit 74406646ab6d49b8633249c0bef9a01ad23c0d3b
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 25 11:36:16 2021 +0900

    update README

commit a341508a5776386fbd4029e42b2f3efb8f1a661f
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 25 03:23:00 2021 +0900

    fix path

commit 5547687d82516e6c8a1350ea246918b1dc269c7e
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 25 03:22:40 2021 +0900

    add onsen

commit fa376fb17ba14fc303a780042cb47e40c4968495
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 25 03:00:45 2021 +0900

    Add a link to Nami

commit 9e4a7e7e2eb2d36fcd27d0d79af9798315580c08
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 25 03:00:25 2021 +0900

    add some comment to Mensae

commit 16bb03128a4695769dae4ba21596330c2b45a88f
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 25 03:00:14 2021 +0900

    update Mn1

commit 575961f73f631b84886c7418b9f34b2ceb0f207c
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 25 01:40:44 2021 +0900

    update Ars and more

commit ffbd31905e0c7fb90e30863cfe339eae813915f4
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 25 00:34:02 2021 +0900

    add some build/run script

commit 5f046f9155823c35c863526f50beb1b6482ef01c
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Dec 24 14:23:44 2021 +0900

    update version and add some assets

commit 25b819e9e0dcbea09105fe1aeabd06f58d9ba1c2
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Feb 23 01:05:49 2021 +0900

    update stack Dockerfile

commit 4cc6ff91b9476a4b69af4cc87193e2d60c5abc49
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Mon Feb 22 21:20:08 2021 +0900

    remove unwanted git in nix Dockerfile

commit dfec9787736de7c63d2393c52d45c529c7d43516
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Mon Feb 22 21:15:50 2021 +0900

    change build method for travis

commit cd050f75b5800dccb5fde261579bca6f994acec7
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Mon Feb 22 20:13:16 2021 +0900

    Update reflex-platform

commit d41808f698f13c920a19a8b398c29f645a1b95a1
Author: Aida Torajiro <aidatorajiro@users.noreply.github.com>
Date:   Mon Feb 22 01:19:31 2021 +0900

    Update .travis.yml

commit 5c1d1c419bdc9c323f11d563bdc6635756e4d24c
Author: Aida Torajiro <aidatorajiro@users.noreply.github.com>
Date:   Mon Feb 22 01:13:39 2021 +0900

    Update .travis.yml

commit af08fdb7c9b5c017cd43bd6750483e75935e163a
Author: Aida Torajiro <aidatorajiro@users.noreply.github.com>
Date:   Mon Feb 22 01:09:57 2021 +0900

    Update .travis.yml

commit bf9cc34d551f15384ec3110927e2b0d02b51c0d0
Author: Aida Torajiro <aidatorajiro@users.noreply.github.com>
Date:   Mon Feb 22 01:05:28 2021 +0900

    Update .travis.yml

commit 40f82bb9fb3850943b6e59e189126ae56efb2e78
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sun Feb 21 23:49:23 2021 +0900

    update default.nix

commit 0a9d91cebe16160239357a98ddd02af2f2b8ed94
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sun Feb 21 23:47:01 2021 +0900

    update .travis.yml

commit 24659cdc359a1c5fc63a64996359cfa20d3ebd5d
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sun Feb 21 23:46:39 2021 +0900

    revert reflex-platform to 8de0583758baddf987588d13df3adc4c6564c504

commit cf9135219817c7d274ed97188362f6e11b8c684d
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Feb 20 14:28:14 2021 +0000

    delete outlimit.py

commit bdc4045871f077acb1466110ea229c0836071b07
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Feb 20 14:27:49 2021 +0000

    Update .travis.yml

commit 188db8f08c26836fbb944933b4e8d8a9f41a4141
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Feb 20 13:56:29 2021 +0000

    update nix build method

commit 0d9323a8c0e9fffbb8d56fd82ea875885e40a0a4
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 19 14:29:05 2021 +0000

    Update .travis.yml

commit 05efbe8888db990d8b1a0e09f828c00775adc552
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 19 14:18:58 2021 +0000

    Update .travis.yml

commit 24e842d325f870f62a75d2bd4476bd0127f98034
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 19 13:55:47 2021 +0000

    Update .travis.yml

commit 956c8d8afbe7ec27d4a5cb3be26865ee6bb70077
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 19 13:23:05 2021 +0000

    Update .travis.yml

commit f7d1a5ce0104268c914a2085cbbe3885d99c97b4
Author: Aida Torajiro <aidatorajiro@users.noreply.github.com>
Date:   Fri Feb 19 21:22:47 2021 +0900

    Update .travis.yml

commit f309bbaf6c3cbd297b9420ab3df0fc22aaea6b15
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 19 18:14:31 2021 +0900

    update travis

commit 6881a5316f4c3daecdcd1a17b2fcc4a70c603d07
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 19 09:03:38 2021 +0000

    refactor code

commit 27f1dde0178f421219a66b779dd0cfb8f80eb6ab
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 19 08:49:04 2021 +0000

    refactor, change links and IClub

commit 0567b9069aa64c63da414e3ac34f19d519d21005
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 19 08:48:00 2021 +0000

    add marukaite.ttf

commit b188adb404e4d63dd4c1c3b646cdffdb5fd05028
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 19 08:47:30 2021 +0000

    add japanese font

commit 3f61dd94833c653ffdb5a408f564ea26cc96a77f
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 19 08:47:19 2021 +0000

    remove stack.linux.yaml

commit dc88eccc2d388ad261ce2e2842f9f51dc0e27802
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 19 08:27:18 2021 +0000

    fix environment variable in run.sh

commit 0719401596a33c9bdc008d81d6113302ba6e178e
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 19 08:26:59 2021 +0000

    Dockerfile: use apt-get instead of apt

commit 6df77fbbb32b7d4c58a270f6a779e904a05eb827
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 19 08:26:37 2021 +0000

    revert last change

commit 7c6b709f54018fa7c77439a37a4ceea5ff776193
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 19 08:25:26 2021 +0000

    add stack.yaml to .gitignore

commit fa10927c19f6c17f0ad21579c22e81cc5cc98ae2
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 19 08:24:57 2021 +0000

    delete stack.yaml

commit 0828288ae33af814774e0226a44b445e263ca9e3
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 19 06:53:44 2021 +0000

    update iclub

commit 335840759df1a41fe2cd2e4cdb0dd973f3fb0460
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 19 06:52:36 2021 +0000

    run `stack build` on `docker build`

commit 4da6207ccc7c4b174394cb634607dd35fd2b80d0
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 19 04:03:08 2021 +0000

    update dockerfile to use X11 forwarding

commit 4ec854b9fd79ee25b9501ce448b1eb380762c5af
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Feb 18 21:20:40 2021 +0000

    Dockerfile - fix libgtk3.0 symbol exposure issue

commit ec76dcfce24c50bc21f0e0e056f934d05b466444
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Feb 18 19:24:07 2021 +0000

    add vscode devcontainer settings

commit 987f8e7f861fcf839eff72ad0d5aeee125692374
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 19 01:57:01 2021 +0900

    update README.md

commit f03ec1006e4d49edfe3b99b1e4c0ab71810a193e
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 19 01:55:47 2021 +0900

    add stack.yaml for linux

commit 5bdc4025000eba7830645c50941695ff98b94c39
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 19 00:49:37 2021 +0900

    build fix and add memo for build

commit 77d069e18e61af50b7adbc8e7ce81677839251ea
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Feb 18 23:14:31 2021 +0900

    update stack yaml

commit 72ccb84087c06eab5f00660e2e5e85b931878507
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Feb 18 21:42:06 2021 +0900

    update reflex-platform

commit 4b3223d9dafb708be775026a99ac85c6857204e0
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Feb 18 17:44:56 2021 +0900

    add asset - daichi.png

commit 3bfa6bbbf5e69bd7796831ea5080ea48acefd9ea
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Feb 15 20:15:58 2020 +0900

    Ubana.hs: add select cursor

commit 0ce3b51f7c4db37d90da95da798adba942203b02
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Feb 15 18:13:24 2020 +0900

    add pages

commit 0067f329c51ff2777f984d6af5c356a11ab1a28c
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Feb 15 17:25:15 2020 +0900

    add comment to run.sh

commit e5a2054a817d2ffaa3549ebd5bd4a1b25360afda
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Feb 15 17:25:00 2020 +0900

    use <> instead of ++

commit 7157dcf89d7ff657fed919781f2c1e0c8863abd7
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Feb 15 17:00:10 2020 +0900

    enclose stateDyn

commit 8f385483e1d03a8fdbab47b0c45e670b6475e132
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Feb 15 16:58:45 2020 +0900

    change initial coord

commit 3303f12b0878e64de0698f2171cc291fda5868ac
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Feb 15 16:57:12 2020 +0900

    update Ars.hs message

commit 287c0cdf0afdf7ce2d5619195cd850a0673f8021
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Feb 15 16:55:41 2020 +0900

    set keep-history to false

commit 88349b06ebefb97c84540e543fec3a608b9b6c59
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Feb 15 00:04:05 2020 +0900

    fix shell command

commit e869fc96925e6a2d3a3d20a7f780032adb6be2d6
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 14 23:35:41 2020 +0900

    update travis

commit e1033089efc73ede4b03aee46b977f33606f3ff3
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 14 23:33:28 2020 +0900

    update nix

commit 5c615ffe52a4f9f6c7d238174d2c09261a8546e3
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 14 23:18:29 2020 +0900

    fix sudo use

commit af5185c67eefdbf9227a18558d73d7552ef70858
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 14 23:18:20 2020 +0900

    fix travis copy dir

commit 0338e6939ec3a2f7d9104a806de9db57ff85238e
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 14 23:08:28 2020 +0900

    update deps in nix

commit 6db9534c4124800004d71ebdf28a8acfb3e329f2
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 14 22:58:48 2020 +0900

    add deps in nix

commit e698b95a898ddba0d1f26b15f18213e138bb364c
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 14 22:45:44 2020 +0900

    change src dir in default.nix

commit 4a1dee99836cbddd1a290616cb88d2b7b7a911ae
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 14 22:22:16 2020 +0900

    update travis

commit ca41deb8681925994ff05909cd22c325e9f67a71
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 14 21:24:01 2020 +0900

    update travis

commit aea5bae4022568d45e446b708e7ed9c249212ffd
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 14 21:20:59 2020 +0900

    update nix

commit 38aed422fd98581352d4450d5c535c01f90cb216
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 14 21:04:35 2020 +0900

    update reflex

commit 7619949edf994048c35527d4fa7c896f28f39599
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 14 20:54:54 2020 +0900

    update ubana

commit c8de3dac2fd02ec4e49777f2ae52a67295858c78
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 14 19:12:07 2020 +0900

    update Ubana

commit 471af5bc441158995b3e5101a5c70388ad72f931
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 14 00:21:06 2020 +0900

    update travis

commit 9f0ff930eddd84bd0d9c77a78f0ac35fc2975709
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Feb 14 00:16:22 2020 +0900

    change sitemap

commit 87f055bdd0ed2d090ea14af29ffc7bea1e4abfc3
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Mon Jan 6 00:34:51 2020 +0900

    More assets!

commit 5e11f2ae6d5d62083716e2db96429bf06c8c1ccc
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 28 23:36:01 2019 +0900

    add warp point

commit e8db1266be5aa69d28c63574ba4e5fba953e6df6
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 28 15:14:42 2019 +0900

    add some document

commit 39400ae29134653b65ba40179806b9c1217d8034
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 28 15:03:40 2019 +0900

    use <> instead of ++

commit a1def761df9bad52da121487ea9df973d15adca6
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 28 15:00:04 2019 +0900

    fix build error

commit 64842597291de60db5067f70157a58728602fc4c
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 28 14:58:36 2019 +0900

    change local server routing

commit 1eea70d20ded3b328a2b3314f88031e8f4bd624c
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 28 14:58:16 2019 +0900

    Update FakeIndex

commit a2a6dfbadf4f80e8b5b807111116bece304d454e
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 28 14:58:07 2019 +0900

    Delete ArsGame

commit c3700d594cdd5a470118a213334f8e64b7ce1e16
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 28 14:57:50 2019 +0900

    Update Ars

commit 2e674a2b6ce013ea105132ffb352dc7307fa9eab
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 28 12:45:34 2019 +0900

    change TODO

commit c57dfe8db17751d3fbbf5c2b4e3d48e314a7d913
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 28 12:45:25 2019 +0900

    Add asset

commit 08b015f0df863dce67f4a7a999dbc8460d770837
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 28 12:44:33 2019 +0900

    Introduce reset css

commit 04701f4796b619cf2f6bbbe1bdbd6475dce1ee69
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Dec 26 21:41:49 2019 +0900

    change bound condition for Nami.hs

commit cd9c45d0382f81064cd91185493796ef43ca6e00
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Dec 26 20:23:50 2019 +0900

    change stack.yaml

commit 8a73959a5f05762e36bcb6dae3ffb8f031a0304e
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Dec 26 20:23:41 2019 +0900

    change stack-ghcjs.yaml

commit 9ac0413ac0fcd837cb9466b775141709b8534909
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Dec 26 20:23:31 2019 +0900

    fix offset error

commit e0e5a046a3c20166e5c6925f2387b603e7e9e4fe
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Dec 26 17:48:54 2019 +0900

    update location maps

commit 8e6a1cc094fa7b8e5c862920b63a11c4dcc2abe7
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Dec 26 17:48:37 2019 +0900

    typo

commit a691a813b31120b99cfda624657cee5379e2e772
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Dec 26 17:48:17 2019 +0900

    change reflex-platform commit

commit f17f4cab4ff81419839c701566bba5a08d99c09e
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Dec 26 16:58:14 2019 +0900

    Update travis

commit 237f112050b71c7f3fd33510e6871d7127d45652
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Dec 26 16:42:57 2019 +0900

    Update travis

commit ca365f9323217dd30f22b52658339b9d582360a2
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Dec 26 16:23:24 2019 +0900

    Update travis

commit 408a0e6d32879c209c053c3ee7f1d55a37572bee
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Dec 26 16:09:12 2019 +0900

    Update reflex

commit e9415b52cdc3102eab9014321c038e2269c9b5dd
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat May 18 21:47:12 2019 +0900

    aaaa

commit f9948590c6ca061855d251016a3b1c537736aae7
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat May 18 21:45:26 2019 +0900

    Add an arrow

commit 154d53f740b6f5f8feddb6bda7b22dcc77a2c4f8
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat May 18 21:38:20 2019 +0900

    delete sentences

commit 5180781aeba5a257404fd51889d155099cd20e99
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sun Apr 28 23:12:39 2019 +0900

    re-map FakeIndex

commit c28cfc937612e72ef3cecabc7f21228a6e8bc5a6
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sun Apr 28 21:08:55 2019 +0900

    fix Mn1.hs

commit 72f8e4c53ff711db3be50984737777d65e5ecbc8
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Tue Apr 23 10:15:46 2019 +0900

    Add answer to mn1

commit 64e95e33ad7b0d7e18ebdde5b22667fccd013c70
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Mon Apr 22 22:14:39 2019 +0900

    add IClub

commit aa84a830599cf259a91294f8f4f8b053fa7c6cf4
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Feb 12 18:10:45 2019 +0900

    update site routing

commit c7c5105049c1d9dfb499ca0775ce40007babbfdf
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Feb 12 18:05:01 2019 +0900

    Update Mn1

commit 152bf8e3b9d0b537291a8d3f22af97998e23624d
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Feb 12 17:44:05 2019 +0900

    update Mn1

commit 4fd4cd6eccdd751b39b8168cb9de7a6e1d163fdb
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Feb 12 17:17:28 2019 +0900

    update Mn1

commit 813fa3a6a088991b663406b4d78fb4d859f3994e
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Feb 12 17:17:23 2019 +0900

    add pir.png

commit 8c3024cc993ca133d098ab8091c8e5eec2de1972
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Mon Jan 28 01:18:10 2019 +0900

    add some images

commit 2ad434d26a036c2cfb3eeb8fcbddc13d04a43678
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Jan 23 17:54:17 2019 +0900

    use `style` instead of `el "style" . text`

commit 412f5c4ff7f0de8307e67c82449670cdd7abbc6d
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Wed Nov 14 13:38:00 2018 +0900

    Add buttons in Mn1

commit 4941e7c175b4720734a4bef5a19f3ba150dd7ec1
Merge: 1576286 dc98fd3
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Nov 8 14:34:09 2018 +0900

    Merge branch 'master' of https://github.com/aidatorajiro/RDWP

commit 15762869a854c69693af7d929019d6302429a7f6
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Nov 8 14:33:59 2018 +0900

    fix direction

commit dc98fd3c7302ffe09aec3c80312461626a3e956f
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Thu Nov 8 09:50:01 2018 +0900

    Modify a comment

commit da88840af196d0c98dba0129a535db3677c3e097
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Nov 7 22:50:07 2018 +0900

    Refactor LibMain.hs

commit c07221dc334ad25fff5fe1c15ddc2a248f52a85b
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Nov 7 22:40:15 2018 +0900

    embed FakeIndex.css to FakeIndex.hs

commit a3642ebc488e2b9decfc59110d691c51881ea720
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Wed Nov 7 22:41:06 2018 +0900

    Update LibMain.hs

commit 5b01e36dfa54ddeca9afe19d9b901378ad3bc0c6
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Nov 6 23:33:32 2018 +0900

    fix location management

commit 4d4e76c84297d94c5d6815c0525fec8f30fe307b
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Nov 6 20:32:12 2018 +0900

    implement stack support

commit 8240c7bc030464ac4c6ef1396d9c968e7fb200ff
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sun Sep 16 17:00:19 2018 +0900

    add comments

commit c61820a54363ccd7b52cc1e42191fa654a223e75
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sun Sep 16 16:59:55 2018 +0900

    fix syntax

commit 0fbf23ba929e2a30577d032c9bd0acc129dce55d
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sun Sep 16 16:45:11 2018 +0900

    update Nami

commit 689c999b1c97512ce12d592d41ee2280789c0047
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Sep 15 22:58:09 2018 +0900

    update reflex-platform

commit 3a25b9cf5c142233c7aa751ca11533b7022038be
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Sep 15 22:57:13 2018 +0900

    update LibMain

commit 7f1ad3bac9a1390510e26d8aa034a9b623f2d15f
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Sat Sep 15 22:29:53 2018 +0900

    update LibMain

commit 968a869932ccf7570a79a4564b38a661fcef583a
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Sat Sep 15 21:54:32 2018 +0900

    add fallback to Error 404

commit cda32605eca290ea28788fa39f432037c21caaaa
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Sat Sep 15 21:52:32 2018 +0900

    change indentation at LibMain

commit 172138a63fcd15515a659e547af901882e321e9c
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Sat Sep 15 19:57:37 2018 +0900

    fix compilation error at ArsGame

commit 46c7ec884b192576a12e5f3f6e4ac15eee4dbe3f
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Sat Sep 15 18:47:20 2018 +0900

    Update ArsGame style

commit 537869b3357edc067f3c03e2ecf9d739058cb6b7
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Sep 15 18:34:31 2018 +0900

    fix routing

commit 1bcf7a61349f3ce6e99a4a38582c9251d22cac45
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Sat Sep 15 12:40:41 2018 +0900

    add ArsGame

commit 8c8e3817f73f8458f3182cad5a600754201fe5b0
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Sat Sep 15 12:39:07 2018 +0900

    fix duplicated style definition

commit 8b0ea733278cea6fb3452e1eea55f172059658c9
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Sat Sep 15 12:33:36 2018 +0900

    fix indentation

commit 4fef9b00e4bcdd804bc6e79b62602a57e01f3598
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Sat Sep 15 12:31:36 2018 +0900

    Update LibMain routing algorithm

commit 159bd9f79fb819f59091dc141f631872cac0546b
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Sat Sep 15 09:10:22 2018 +0900

    Update Ars

commit d4d9c89af52f8dfb2e2337c23a9f0a830e4f8e38
Author: Aida Torajiro <aidatorajiro@users.noreply.github.com>
Date:   Thu Sep 13 02:14:39 2018 +0900

    Update .travis.yml

commit b539bc080abe9c9be267f03a423b03ebf658016f
Author: Aida Torajiro <aidatorajiro@users.noreply.github.com>
Date:   Thu Sep 13 01:49:42 2018 +0900

    Update .travis.yml

commit 28e26edaa1b01fb63ed5bcd399ede61c170f5f18
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Sep 13 00:55:15 2018 +0900

    update Ars

commit 4faea421ba48653d629f15678d963d1549a1f7db
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Sep 12 23:03:39 2018 +0900

    update Mensae

commit 473b8139bbdcd6c4dbf25d837116e3fe5c8ac62a
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Sep 12 23:03:24 2018 +0900

    modify bs-config

commit d42a75e152fb590aa3ea24b15955a1d412724b32
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Sep 12 23:02:52 2018 +0900

    modifie style

commit 062b8e90d7b67d6ee3b201248e18b4c2e3b915b9
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Sep 12 23:02:10 2018 +0900

    delete files

commit c8aba943451e618dbd50ea64f58755af82fcb99e
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Sep 12 21:23:13 2018 +0900

    update Mensae

commit aff02c0ab84387678c0b8b4bbb2f58adc2cc65bb
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Sep 12 20:23:29 2018 +0900

    update style

commit 1780645fe35548f7f6c81d572f400f95b7750ab8
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Sep 12 20:19:49 2018 +0900

    fix Ars

commit 29bd1daaa9ad7086d19292dd06f3f4e927b302aa
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Sep 12 20:18:04 2018 +0900

    update Ars, LibMain, and Mensae.

commit e79b158c69848d3e09c17651f8fc887013c457e5
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Sep 12 16:22:20 2018 +0900

    updated reflex-platform

commit 6da44a18f8006c5df65ad9b0275bf9c3853ef46f
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Wed Sep 12 15:37:04 2018 +0900

    Add Ars.hs

commit e8d56a09abe5ef528ca3fb4e6115804cfe9d75f5
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Mon Sep 10 23:25:17 2018 +0900

    change Mensae

commit 316d46c17db3232956a34985c88904bc9b1615b2
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Mon Sep 10 20:12:06 2018 +0900

    change Mensae.hs

commit c38ee35dfebac7acd8648648f3a8b94387a1df2a
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Mon Sep 10 20:11:51 2018 +0900

    simplify LibMain.hs

commit 9873e680e66ff0e0c3161f657a32116fdf7136f1
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Mon Sep 10 20:11:34 2018 +0900

    use leftmost

commit c5d4dd625e34eff242f9155116768f172aacc05b
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Mon Sep 10 18:28:43 2018 +0900

    update Mensae

commit 93a67500e1316dea623ec37841cb018db19123f1
Merge: 8eb3683 deeaf93
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Mon Sep 10 17:46:50 2018 +0900

    Merge branch 'master' of https://github.com/aidatorajiro/RDWP

commit deeaf938d3496ffdd190868ed8481b74c9f52b2c
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Mon Sep 10 17:40:39 2018 +0900

    Changed Fakeindex and Mensae

commit 8eb36833e59f4ed7a964b0b78e1ed3a121eff9a8
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Sep 4 00:15:52 2018 +0900

    changed REDAME and bs-config

commit 8f5c8268e856cbce3eb10e8f997c09979dd23b0d
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Sep 4 00:08:37 2018 +0900

    changed variable name

commit a60221a60c7a2953d918e36095756d7bdac0f951
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Mon Aug 6 15:32:46 2018 +0000

    update LibMain.hs

commit 67690ffd2e88d8c57fdfa2fd376b6f2cbf95f90c
Merge: f80c9dd fc45af8
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Mon Aug 6 15:19:23 2018 +0000

    fix tab to spaces

commit f80c9ddc464fadab2f8475640af169740ce2f060
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Mon Aug 6 15:17:28 2018 +0000

    update LibMain.hs

commit fc45af8f15e7c35eca1db9e16363af65a97af23f
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Mon Aug 6 23:12:11 2018 +0900

    update LibMain.hs

commit 154f48d8d91547f612eb1e8bf2e8e1248c3fc934
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Mon Aug 6 09:57:49 2018 +0000

    update LibMain.hs

commit 65fa57ef8e38a7af3fca8d164ca19bc89d9f731b
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Mon Aug 6 09:14:11 2018 +0000

    Add HTML5 History API compatibility

commit 646e6742fa7584338908661b6f2d033d6511eb74
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Mon Aug 6 12:51:59 2018 +0900

    change travis

commit 82c8b005c26cb9cf03451c541575d0df8fcb7864
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Sat Jun 16 14:13:17 2018 +0900

    flip axis

commit 6b1cb2d2b6b5dd56a264daa20dff36c29158aa54
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Jun 9 18:53:53 2018 +0900

    fix Nami.hs

commit 5100ead274408e8dce1330fb668252dfa5a4c08f
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Jun 9 18:15:37 2018 +0900

    fix Nami.hs

commit 41d15ec7a777cf331748f223dbaa341512f762ee
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Jun 9 18:10:00 2018 +0900

    add buttons to Nami

commit 1d7eab4ece5ba5bbcd83ccc3fed290f0da9ff2fb
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Jun 9 17:48:08 2018 +0900

    remove 'fold' from Nami.hs

commit c095bf05debd54de7a2b9a67ea07aa352f1be16d
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Sat Jun 9 12:25:45 2018 +0900

    disable cache

commit 75405f04a631d18484e616c37cd5a99a1c6270e3
Author: Aida Torajiro <aidatorajiro@users.noreply.github.com>
Date:   Sat Jun 9 10:44:23 2018 +0900

    Update README.md

commit 1a1e6aafa1fdec72d451c653ed9a1fa0a33ca8c2
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Sat Jun 9 09:38:45 2018 +0900

    Extend cash timeout

commit 39073544812055a639431d814dde1f8bf775ef11
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Jun 9 02:36:02 2018 +0900

    set keep-history to true

commit 3e8a78fca33543e9ba2f557ba77383aea977769a
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Jun 9 02:23:32 2018 +0900

    fix travis

commit 55181f0452ab81d6fda8ea42724bf00a50e77abb
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Jun 9 02:13:45 2018 +0900

    set keep-history to true

commit 1fec8b87503c5f49b0c4979c7e760502dc0d025f
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Jun 9 02:11:13 2018 +0900

    add gh pages deploy

commit 97e0eaf9e20e5aee34f2a1f085bc869fcb05b845
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Jun 9 02:01:14 2018 +0900

    fix travis

commit a4c678971fd9ef94b35fd71499557aa85ebc7364
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Jun 9 01:32:46 2018 +0900

    fix travis

commit 59234cf5d8f026b3c53adba0d9b70826c2d110b2
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Jun 9 01:18:58 2018 +0900

    cache /nix directory in nix

commit a22b244da2b02f894e983731ea7aa55b92648344
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Jun 9 01:16:50 2018 +0900

    fix travis

commit 53ff905e26f3c59d95cb72b81bfebf62723e0654
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Jun 9 01:13:09 2018 +0900

    add gh-pages deployment in travis

commit c0657ee86338697dd1dc3961918fc8b36912d82d
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Jun 8 14:33:06 2018 +0000

    add public key to travis

commit b6fb1aa87449cdf95bae8862cce5bdaacff92300
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Jun 8 13:33:38 2018 +0000

    update travis (set language to nix)

commit ef071b72ab82b92ebe2434d2ed1bff09c024ef20
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Jun 8 07:13:12 2018 +0000

    update nami

commit 5d2f6214e7d6888d275592cdc4f82b245790c4b6
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Jun 7 13:09:08 2018 +0000

    implemented Nami

commit 5cdd8950d7e4a3a4618ea9dc31a701da2dbdd5f1
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Jun 5 14:18:46 2018 +0000

    fix compile error

commit e62b8f98faf123f144f4a42d1508317cd3998b8c
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Tue Jun 5 22:27:55 2018 +0900

    refactor and update Nami

commit ed3a7492a440be584b8786ef248bdb2a12a26142
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Tue Jun 5 19:43:10 2018 +0900

    fix event calculations

commit 62aefd83c17ae6beb8d65c89b378c60a400543a9
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Jun 5 08:50:54 2018 +0000

    fix location bug

commit 76e64588c82b110ee13ea87d8cbfb4463cd798cf
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Tue Jun 5 09:33:08 2018 +0900

    fix dependency

commit d623630dab4539b68aafbcf4f25f244329ced574
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Mon Jun 4 23:13:43 2018 +0000

    introduced reactive routing

commit 25d5573ceece9bdee2edc684446b193012775c1c
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Tue Jun 5 00:00:52 2018 +0900

    fix syntax

commit 5522a85c5e7593aee0736383c315e14e8b3f9e88
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Mon Jun 4 23:57:49 2018 +0900

    import <>

commit 58aa5107429d7367e7678ec13b0c8055b1ebf181
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Mon Jun 4 23:53:54 2018 +0900

    fix syntax

commit e88ba9cd1c127a3a6a5d4b11e3c6ae99f9de5586
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Mon Jun 4 23:40:17 2018 +0900

    fix # of args

commit 044064fada2181490f86b6fe57dd4c8a0f386846
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Mon Jun 4 23:37:54 2018 +0900

    fix number of arguments (again)

commit 615fd56039428ff82810d79e99c0a6a9ade40479
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Mon Jun 4 23:35:12 2018 +0900

    fix number of argument

commit fac89d896c97c862e20bb4330277f5b2e01aa059
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Mon Jun 4 23:29:41 2018 +0900

    change routing

commit 4efadea65f30e9cc7e837dc9becb932c09b8197b
Author: Aida Torajiro <aidatorajiro@users.noreply.github.com>
Date:   Tue Mar 27 21:46:17 2018 +0900

    uodated travis

commit 83584155118d950c7e32b7cc3b8de52b0bf21e92
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Tue Mar 27 21:19:24 2018 +0900

    renamed Mn1.ha to Mn1.hs

commit 0a3920bc0cdd31f36854616093acccdf9f615ab1
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Tue Mar 27 21:17:22 2018 +0900

    updated travis

commit da0ff1971c930dd2fc4718e57ce0cafbf24e1455
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Tue Mar 27 18:44:21 2018 +0900

    added some pages

commit 5fcff4ccbeeb13fa2d5894794b0a2ddde11a1c8e
Author: Aida Torajiro <kawarusosu@zoho.com>
Date:   Sat Mar 24 15:56:26 2018 +0900

    updated travis

commit 024dde818ba3c45aa6df729845a112903b209bd6
Author: Aida Torajiro <aidatorajiro@users.noreply.github.com>
Date:   Sat Mar 17 19:55:01 2018 +0900

    Delete result

commit c9be18d979d30b5ee32efd7001cfa0a2b8699f35
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Mar 16 19:22:35 2018 +0900

    updated travis

commit a45160c92adafb90f2eee50b59592bcc2831810c
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Mar 16 19:19:37 2018 +0900

    added LICENSE to root

commit 2d103b8a7abd026703a4d5059aacb7d2a2e44df1
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Mar 14 23:51:12 2018 +0900

    Revert "use language nix in travis"
    
    This reverts commit aa97e09fba9e23514c94ddd03b73057cc974894e.

commit aa97e09fba9e23514c94ddd03b73057cc974894e
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Mar 14 23:41:26 2018 +0900

    use language nix in travis

commit 45e57ee0635c44d2e97d6b16445b6f7720147d9a
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Mar 14 23:35:41 2018 +0900

    update travis / removed deploy file

commit 67e978f43869e1cfff4ddb8683b7bcbeef7d6152
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Mar 14 23:33:40 2018 +0900

    deleted deploy

commit a40ff35062393c2233172ea955b2dcf87f947a32
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Mar 14 22:52:23 2018 +0900

    update travis

commit af4d6b803769cb4a50b12cd035acbec08e79cb20
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Mar 14 22:19:12 2018 +0900

    updated travis

commit e711d32722353469a89c7d9074d90b369a73389e
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Mar 14 21:45:45 2018 +0900

    updated travis

commit 26a8975d9cfa168bbec30ad221c871865ad7a0b7
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Mar 14 20:06:35 2018 +0900

    switched to nix

commit 299560b4ce526750cebc3c92847173043eb4f81c
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sun Mar 4 12:28:34 2018 +0900

    update travis

commit 1b82bfc357dd1b15100785312334e67d20509276
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Jan 13 16:49:36 2018 +0900

    use stack as travis build system

commit ad87ef35c8b3c534335e332de0e15101db680152
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Jan 11 00:30:50 2018 +0900

    update travis

commit c9f8513d09e886a69bec31caba42437816c92399
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Jan 11 00:27:32 2018 +0900

    bracket fix / update travis

commit 81f135e28195d038a38365c8345ea9615cf52a6e
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Thu Jan 11 00:24:21 2018 +0900

    update travis

commit 99d7df33b33fe3fa2376731492f47dba2c3f7af4
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Jan 10 23:13:46 2018 +0900

    change travis build setting

commit 5dc1cc6b2b43c626b952253b9656bc3c21805dbf
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Jan 10 23:12:24 2018 +0900

    nix fix (webkitgtk issue)

commit ddcf3c93eeb1e2e6bf59f7f05f8a4a11565e8291
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Jan 10 23:05:46 2018 +0900

    fix nix again

commit 8c849ef70fb927756bf705937babf03e2b6156a7
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Jan 10 23:00:31 2018 +0900

    fix nix again

commit a19f8ed223a13445c28cabc368c545cb4e4b1916
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Jan 10 22:58:01 2018 +0900

    fix nix again

commit 4ff5feb3826f7e219a94a6a34a6951d481f26bd5
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Jan 10 22:55:02 2018 +0900

    fix nix

commit 9fb692d3e6669aac9c2f5df7551f79179e6f9209
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Jan 10 22:51:38 2018 +0900

    add nix

commit 668490d95eba8b2baed8093629a0726abde166df
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Jan 10 21:57:17 2018 +0900

    native ghc hack

commit d6868f6e9c552ea7b679e8a0d40bbc2256474ed8
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Jan 9 20:38:57 2018 +0900

    changed function name

commit b585731acca1dfeb7f05fc4b1d03dbcacaa20024
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Jan 9 20:38:11 2018 +0900

    use parsec

commit 0a0107bbd8655cf23fa3b92e4e6d7baf7fd0e8a5
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Jan 9 20:38:04 2018 +0900

    update stack version

commit 21513ca85fa681f996f6fa0a759fbfe5300fb652
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 2 21:39:41 2017 +0900

    add libraries to readme

commit 894f82d2bcd9e5095ac638a59a36e1e517987ca0
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 2 15:24:52 2017 +0900

    update FakeIndex

commit 2749a2d393e631f8240dc2687ced1f073c59e83a
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 2 15:10:43 2017 +0900

    update readme

commit 198d42a3f0f1958dd1de85fa26b1b8100f9bad0b
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Dec 2 13:20:08 2017 +0900

    update readme

commit e5cc3dca9ddfc82a584175595f2c9b0dd9f3a0e3
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Nov 29 20:10:58 2017 +0900

    use M.singleton instead of M.fromList

commit 78e9614ee5563dec0bf2c734144e1fbc28453be8
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Nov 29 20:01:25 2017 +0900

    change comment

commit 916d044e654888ce51eb1cb5e341853728424496
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Nov 29 19:40:15 2017 +0900

    beautify code

commit 6ff7e8d9543d4927208629a8c28b20683f16baf0
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Nov 29 18:36:10 2017 +0900

    add comment

commit f7dd045243cbfcab96f1a9e1c9f49370df307879
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Nov 29 18:32:41 2017 +0900

    fixed few mistakes

commit 4dd6ffb396c2e78621a9646951ba49ed01037f3f
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Nov 28 19:03:37 2017 +0900

    impremented toppage

commit e5de4eded5042f8123ac64bab85cf24bf51782c6
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Nov 11 20:38:38 2017 +0900

    add Elements and updated FakeIndex

commit 5dedf5b236c283ee66c3af07347e5a2bdb5ade27
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Nov 11 20:38:05 2017 +0900

    added source section

commit d1abeb632d4b658c6821d95a84a78a503ea4c7bf
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sat Nov 11 15:05:59 2017 +0900

    add asset

commit f0449175203f909299a7affe2633c9bcf556d9f1
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Nov 10 18:19:06 2017 +0900

    Revert "Add comments.". Silence is golden.
    
    This reverts commit 5f4dfc32dd24630eff6499f3119d141a4b3ceff9.

commit 5f4dfc32dd24630eff6499f3119d141a4b3ceff9
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Fri Nov 10 18:14:22 2017 +0900

    Add comments.

commit a2435699611f9a7a257ca23eac8fd7e448cff75e
Merge: a056cfe 7783727
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Nov 8 16:06:43 2017 +0900

    Merge branch 'master' of github.com:aidatorajiro/RDWP

commit a056cfe75bedce14a05672ea4418cf2c0f7a4428
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Nov 8 16:06:21 2017 +0900

    Cabalfile fix

commit 8eda294a9c04eea6484357c36d37877497202cec
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Wed Nov 8 16:04:55 2017 +0900

    Routing fix

commit dbfb179744481c14d1dc7418a1297185f873a485
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Nov 7 22:03:41 2017 +0900

    add page Mensae (The vocative form of "table" in Latin)

commit 778372782be35ea9fd46a70fa34c00b03a356e01
Author: Aida Torajiro <aidatorajiro@users.noreply.github.com>
Date:   Tue Nov 7 21:55:42 2017 +0900

    typo

commit ec9cdc067f06702ed207fd98a0676218c6da3bc5
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Nov 7 21:53:01 2017 +0900

    add Readme

commit 3f7529d7b1086a1415f1575e2af7ae41cea08517
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Nov 7 21:52:53 2017 +0900

    Modify bs-config.js so that browser-sync servers will reload on building

commit 73d4ff8030bdb61cb1d415522f90025b2494cf17
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Nov 7 21:51:47 2017 +0900

    Change a little

commit fef3e6b2a3456a60b7eee0184cd9c916ae271268
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Nov 7 21:51:38 2017 +0900

    Linted Index.hs

commit 51f9d7d70a5f645ed9114f8cd8d58ab0698a37ad
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Nov 7 16:43:47 2017 +0900

    update Index

commit 6b1382649b0f07666c5b11537234a8b821da73d8
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Nov 7 16:24:01 2017 +0900

    Add settings for browser-sync server

commit b3cdc5c0b4d7692bd2b7addf2bb50ddb8eb0f414
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Nov 7 16:23:34 2017 +0900

    SIP routing

commit 639abf73b151c23baf3b02383aef9e5d5b068da6
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Nov 7 15:36:12 2017 +0900

    linted Index

commit 18251646e54f6f331d12e8c784ff2b7879427777
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Tue Nov 7 15:19:01 2017 +0900

    update Index / add Util

commit 62e6780f4fe6aa49e01accd040b114cd21c5f31b
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Mon Nov 6 02:13:27 2017 +0900

    update Index

commit 88d4acc34b567e9a24dafe9d0ad3c4a0edb18f09
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Mon Nov 6 02:12:47 2017 +0900

    update Index / add FakeIndex (routed to /)

commit 876f663115c43815a6d9222bc647e69aa49578d3
Author: aidatorajiro <kawarusosu@zoho.com>
Date:   Sun Nov 5 23:54:04 2017 +0900

    first commit
|]