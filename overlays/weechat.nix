final: prev: {
  weechat = with prev.weechatScripts;
    prev.weechat.override {
      configure = { availablePlugins, ... }: { scripts = [ multiline ]; };
    };
}
