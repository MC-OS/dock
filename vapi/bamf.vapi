/* bamf.vapi generated by vapigen, do not modify. */

[CCode (cprefix = "Bamf", lower_case_cprefix = "bamf_")]
namespace Bamf {
	[CCode (cheader_filename = "libbamf/libbamf.h", type_check_function = "BAMF_IS_APPLICATION")]
	public class Application : Bamf.View {
		[CCode (has_construct_function = false)]
		protected Application ();
		public unowned string? get_application_type ();
		public unowned string? get_desktop_file ();
		public bool get_show_menu_stubs ();
		public GLib.List<weak Bamf.View>? get_windows ();
		public GLib.Array<uint32>? get_xids ();
		public virtual signal void window_added (Bamf.View p0);
		public virtual signal void window_removed (Bamf.View p0);
	}
	[CCode (cheader_filename = "libbamf/libbamf.h", type_check_function = "BAMF_IS_CONTROL")]
	public class Control : GLib.Object {
		[CCode (has_construct_function = false)]
		protected Control ();
		public static unowned Bamf.Control get_default ();
		public void insert_desktop_file (string desktop_file);
		public void register_application_for_pid (string application, int32 pid);
		public void register_tab_provider (string path);
		public void set_approver_behavior (int32 behavior);
	}
	[CCode (cheader_filename = "libbamf/libbamf.h", type_check_function = "BAMF_IS_INDICATOR")]
	public class Indicator : Bamf.View {
		[CCode (has_construct_function = false)]
		protected Indicator ();
		public unowned string? get_dbus_menu_path ();
		public unowned string? get_remote_address ();
		public unowned string? get_remote_path ();
	}
	[CCode (cheader_filename = "libbamf/libbamf.h", type_check_function = "BAMF_IS_MATCHER")]
	public class Matcher : GLib.Object {
		[CCode (has_construct_function = false)]
		protected Matcher ();
		public bool application_is_running (string application);
		public unowned Bamf.Application? get_active_application ();
		public unowned Bamf.Window? get_active_window ();
		public unowned Bamf.Application? get_application_for_desktop_file (string desktop_file_path, bool create_if_not_found);
		public unowned Bamf.Application? get_application_for_window (Bamf.Window window);
		public unowned Bamf.Application? get_application_for_xid (uint32 xid);
		public GLib.List<weak Bamf.View>? get_applications ();
		public static unowned Bamf.Matcher get_default ();
		public GLib.List<weak Bamf.View>? get_running_applications ();
		public GLib.List<weak Bamf.View>? get_tabs ();
		public GLib.List<weak Bamf.View>? get_window_stack_for_monitor (int monitor);
		public GLib.List<weak Bamf.View>? get_windows ();
		public GLib.Array<uint32>? get_xids_for_application (string application);
		public void register_favorites ([CCode (array_length = false)] string[] favorites);
		public virtual signal void active_application_changed (Bamf.View? p0, Bamf.View? p1);
		public virtual signal void active_window_changed (Bamf.View? p0, Bamf.View? p1);
		public virtual signal void stacking_order_changed ();
		public virtual signal void view_closed (Bamf.View p0);
		public virtual signal void view_opened (Bamf.View p0);
	}
	[CCode (cheader_filename = "libbamf/libbamf.h", type_check_function = "BAMF_IS_TAB_SOURCE")]
	public class TabSource : GLib.Object {
		[CCode (has_construct_function = false)]
		protected TabSource ();
		public unowned string get_tab_ids ();
		public unowned GLib.Array get_tab_preview (string tab_id);
		public unowned string get_tab_uri (string tab_id);
		public uint32 get_tab_xid (string tab_id);
		public virtual void show_tab (string tab_id, GLib.Error error);
		[NoWrapper]
		public virtual unowned string tab_ids ();
		[NoWrapper]
		public virtual unowned GLib.Array tab_preview (string tab_id);
		[NoWrapper]
		public virtual unowned string tab_uri (string tab_id);
		[NoWrapper]
		public virtual uint32 tab_xid (string tab_id);
		[NoAccessorMethod]
		public string id { owned get; set construct; }
		public virtual signal void tab_closed (string p0);
		public virtual signal void tab_opened (string p0);
		public virtual signal void tab_uri_changed (string p0, string p1, string p2);
	}
	[CCode (cheader_filename = "libbamf/libbamf.h", type_check_function = "BAMF_IS_VIEW")]
	public class View : GLib.InitiallyUnowned {
		[CCode (has_construct_function = false)]
		protected View ();
		[NoWrapper]
		public virtual Bamf.ClickBehavior click_behavior ();
		public virtual GLib.List<weak Bamf.View>? get_children ();
		public Bamf.ClickBehavior get_click_suggestion ();
		public virtual unowned string? get_icon ();
		public virtual unowned string? get_name ();
		public unowned string? get_view_type ();
		public virtual bool is_active ();
		public bool is_closed ();
		public virtual bool is_running ();
		public bool is_sticky ();
		public virtual bool is_urgent ();
		[CCode (cname = "bamf_view_user_visible")]
		public bool is_user_visible ();
		[NoWrapper]
		public virtual void set_path (string path);
		public void set_sticky (bool value);
		[NoWrapper]
		public virtual unowned string view_type ();
		[NoAccessorMethod]
		public bool active { get; }
		[NoAccessorMethod]
		public string path { owned get; }
		[NoAccessorMethod]
		public bool running { get; }
		[NoAccessorMethod]
		public bool urgent { get; }
		[NoAccessorMethod]
		public bool user_visible { get; }
		public virtual signal void active_changed (bool active);
		public virtual signal void child_added (Bamf.View? child);
		public virtual signal void child_removed (Bamf.View? child);
		public virtual signal void closed ();
		public virtual signal void name_changed (string old_name, string new_name);
		public virtual signal void running_changed (bool running);
		public virtual signal void urgent_changed (bool urgent);
		public virtual signal void user_visible_changed (bool user_visible);
	}
	[CCode (cheader_filename = "libbamf/libbamf.h", type_check_function = "BAMF_IS_WINDOW")]
	public class Window : Bamf.View {
		[CCode (has_construct_function = false)]
		protected Window ();
		public unowned string? get_application_id ();
		public unowned string? get_dbus_menu_object_path ();
		public int get_monitor ();
		public unowned Bamf.Window? get_transient ();
		public unowned string? get_unique_bus_name ();
		public Bamf.WindowType get_window_type ();
		public uint32 get_xid ();
		public ulong last_active ();
		public Bamf.WindowMaximizationType maximized ();
		public virtual signal void maximized_changed (int old_value, int new_value);
		public virtual signal void monitor_changed (int old_value, int new_value);
	}
	[CCode (cheader_filename = "libbamf/libbamf.h", cprefix = "BAMF_CLICK_BEHAVIOR_", has_type_id = false)]
	public enum ClickBehavior {
		NONE,
		OPEN,
		FOCUS,
		FOCUS_ALL,
		MINIMIZE,
		RESTORE,
		RESTORE_ALL,
		PICKER
	}
	[CCode (cheader_filename = "libbamf/libbamf.h", cprefix = "BAMF_WINDOW_", has_type_id = false)]
	public enum WindowMaximizationType {
		FLOATING,
		HORIZONTAL_MAXIMIZED,
		VERTICAL_MAXIMIZED,
		MAXIMIZED
	}
	[CCode (cheader_filename = "libbamf/libbamf.h", cprefix = "BAMF_WINDOW_", has_type_id = false)]
	public enum WindowType {
		NORMAL,
		DESKTOP,
		DOCK,
		DIALOG,
		TOOLBAR,
		MENU,
		UTILITY,
		SPLASHSCREEN
	}
}
