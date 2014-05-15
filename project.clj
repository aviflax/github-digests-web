(defproject github-digest-server "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.5.1"]
                 [resourceful "0.1.1"]
                 [enlive "1.1.5"]
                 [com.cemerick/friend "0.2.0"]
                 [friend-oauth2 "0.1.1"]]
  :main ^:skip-aot github-digest-server.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})
