#!/usr/bin/env python3
import sys
import gi

gi.require_version("Gtk", "4.0")
gi.require_version("Adw", "1")
gi.require_version("WebKit", "6.0")
gi.require_version("Gdk", "4.0")

from gi.repository import Gtk, Adw, WebKit, Gio, Gdk


class KashoobApp(Adw.Application):
    def __init__(self):
        super().__init__(
            application_id="com.kashoob.app", flags=Gio.ApplicationFlags.FLAGS_NONE
        )
        self.connect("activate", self.on_activate)

    def on_activate(self, app):
        style_manager = Adw.StyleManager.get_default()
        style_manager.set_color_scheme(Adw.ColorScheme.PREFER_DARK)

        window = Adw.ApplicationWindow(application=app)
        window.set_title("Kashoob")
        window.set_default_size(1100, 800)

        self.web_view = WebKit.WebView()

        # Set base background to dark to prevent white flashes
        rgba = Gdk.RGBA()
        rgba.parse("#18181B")
        self.web_view.set_background_color(rgba)

        user_content_manager = self.web_view.get_user_content_manager()
        css = """
        /* Hide the Iran flag at the very top, but KEEP the original Kashoob navbar! */
        .katibeh-iran, .katibeh-bar { display: none !important; }
        
        /* Prevent horizontal scroll bugs (white space on the right side) */
        html, body {
            overflow-x: hidden !important;
            background-color: #18181B !important;
        }
        """
        style_sheet = WebKit.UserStyleSheet(
            css,
            WebKit.UserContentInjectedFrames.ALL_FRAMES,
            WebKit.UserStyleLevel.USER,
            None,
            None,
        )
        user_content_manager.add_style_sheet(style_sheet)

        self.web_view.load_uri("https://kashoob.com/")

        # Keyboard Shortcuts
        key_ctrl = Gtk.EventControllerKey.new()
        key_ctrl.connect("key-pressed", self.on_key_pressed, window)
        window.add_controller(key_ctrl)

        # Add a minimal header bar so the window can be dragged, minimized, and closed!
        toolbar_view = Adw.ToolbarView()
        header_bar = Adw.HeaderBar()
        header_bar.add_css_class("flat")  # Keeps it sleek and minimal
        toolbar_view.add_top_bar(header_bar)

        toolbar_view.set_content(self.web_view)
        window.set_content(toolbar_view)
        window.present()

    def on_key_pressed(self, controller, keyval, keycode, state, window):
        if keyval == Gdk.KEY_F5 or (
            keyval == Gdk.KEY_r and (state & Gdk.ModifierType.CONTROL_MASK)
        ):
            self.web_view.reload()
            return True
        if keyval == Gdk.KEY_Left and (state & Gdk.ModifierType.ALT_MASK):
            self.web_view.go_back()
            return True
        if keyval == Gdk.KEY_q and (state & Gdk.ModifierType.CONTROL_MASK):
            window.close()
            return True
        return False


if __name__ == "__main__":
    app = KashoobApp()
    sys.exit(app.run(sys.argv))
