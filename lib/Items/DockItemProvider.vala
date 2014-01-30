//
//  Copyright (C) 2011-2013 Robert Dyer, Rico Tzschichholz
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

using Gee;

using Plank.Services;

namespace Plank.Items
{
	/**
	 * A container and controller class for managing dock items on a dock.
	 */
	public class DockItemProvider : GLib.Object
	{
		static PlaceholderDockItem placeholder_item;
		
		static construct
		{
			placeholder_item = new PlaceholderDockItem ();
		}
		
		/**
		 * Triggered when the items collection has changed.
		 *
		 * @param added the list of added items
		 * @param removed the list of removed items
		 */
		public signal void items_changed (Gee.List<DockItem> added, Gee.List<DockItem> removed);
		
		/**
		 * Triggered when the state of an item changes.
		 */
		public signal void item_state_changed ();
		
		/**
		 * Triggered anytime item-positions were changed.
		 */
		public signal void item_positions_changed (Gee.List<unowned DockItem> items);
		
		/**
		 * The ordered list of the visible dock items.
		 */
		public ArrayList<DockItem> Items {
			get {
				return visible_items;
			}
		}
		
		protected ArrayList<DockItem> visible_items;
		protected ArrayList<DockItem> internal_items;
		
		/**
		 * Creates a new container for dock items.
		 */
		public DockItemProvider ()
		{
			Object ();
		}
		
		construct
		{
			visible_items = new ArrayList<DockItem> ();
			internal_items = new ArrayList<DockItem> ();
			
			item_signals_connect (placeholder_item);
		}
		
		~DockItemProvider ()
		{
			item_signals_disconnect (placeholder_item);
			
			visible_items.clear ();
			
			var items = new HashSet<DockItem> ();
			items.add_all (internal_items);
			foreach (var item in items) {
				remove_item_without_signaling (item);
				item.Provider = null;
			}
			internal_items.clear ();
		}
		
		/**
		 * Adds a dock item to the collection.
		 *
		 * @param item the dock item to add
		 */
		public void add_item (DockItem item)
		{
			if (internal_items.contains (item)) {
				critical ("Item '%s' already exists in this item-provider.", item.Text);
				return;
			}
			
			add_item_without_signaling (item);
			
			update_visible_items ();
		}
		
		/**
		 * Removes a dock item from the collection.
		 *
		 * @param item the dock item to remove
		 */
		public void remove_item (DockItem item)
		{
			if (!internal_items.contains (item)) {
				critical ("Item '%s' does not exist in this item-provider.", item.Text);
				return;
			}
			
			remove_item_without_signaling (item);
			
			update_visible_items ();
		}
		
		protected void handle_item_state_changed ()
		{
			item_state_changed ();
		}
		
		protected virtual void update_visible_items ()
		{
			Logger.verbose ("DockItemProvider.update_visible_items ()");
			
			var old_items = new ArrayList<DockItem> ();
			old_items.add_all (visible_items);
			
			visible_items.clear ();
			
			foreach (var item in internal_items)
				if (item.IsVisible)
					visible_items.add (item);
			
			var added_items = new ArrayList<DockItem> ();
			added_items.add_all (visible_items);
			added_items.remove_all (old_items);
			
			var removed_items = old_items;
			removed_items.remove_all (visible_items);
			
			if (visible_items.size <= 0)
				visible_items.add (placeholder_item);
			
			if (added_items.size > 0 || removed_items.size > 0)
				items_changed (added_items, removed_items);
		}
		
		protected void handle_setting_changed ()
		{
			update_visible_items ();
		}
		
		/**
		 * Move an item to the position of another item.
		 * This shifts all items which are between these two items.
		 *
		 * @param move the item to move
		 * @param target the item of the new position
		 */
		public virtual void move_item_to (DockItem move, DockItem target)
		{
			if (move == target || !internal_items.contains (target))
				return;
			
			var index_target = internal_items.index_of (target);
			internal_items.remove (move);
			internal_items.insert (index_target, move);
			
			if (visible_items.contains (move) && (index_target = visible_items.index_of (target)) >= 0) {
				visible_items.remove (move);
				visible_items.insert (index_target, move);
				
				var moved_items = new ArrayList<unowned DockItem> ();
				moved_items.add (move);
				moved_items.add (target);
				item_positions_changed (moved_items);
			} else {
				update_visible_items ();
			}
		}
		
		/**
		 * Reset internal buffers of all items.
		 */
		public void reset_item_buffers ()
		{
			foreach (var item in internal_items)
				item.reset_buffers ();
		}
		
		public virtual bool item_exists_for_uri (string uri)
		{
			foreach (var item in internal_items)
				if (item.Launcher == uri)
					return true;
			
			return false;
		}
		
		public virtual void add_item_with_uri (string uri, DockItem? target = null)
		{
			warning ("Not implemented by default");
		}
		
		protected virtual void add_item_without_signaling (DockItem item)
		{
			if (item.Position > -1 && item.Position <= internal_items.size) {
				internal_items.insert (item.Position, item);
			} else {
				internal_items.add (item);
			}
			
			item.Provider = this;
			item.AddTime = new DateTime.now_utc ();
			item_signals_connect (item);
		}
		
		/**
		 * Replace an item with another item.
		 *
		 * @param new_item the new item
		 * @param old_item the item to be replaced
		 */
		public virtual void replace_item (DockItem new_item, DockItem old_item)
		{
			if (new_item == old_item || !internal_items.contains (old_item))
				return;
			
			Logger.verbose ("DockItemProvider.replace_item (%s[%s, %i] > %s[%s, %i])", old_item.Text, old_item.DockItemFilename, (int)old_item, new_item.Text, new_item.DockItemFilename, (int)new_item);
			
			item_signals_disconnect (old_item);
			
			var index = internal_items.index_of (old_item);
			internal_items.remove (old_item);
			old_item.Provider = null;
			internal_items.insert (index, new_item);
			new_item.Provider = this;
			
			new_item.AddTime = old_item.AddTime;
			new_item.Position = old_item.Position;
			item_signals_connect (new_item);
			
			if ((index = visible_items.index_of (old_item)) >= 0) {
				visible_items.remove (old_item);
				visible_items.insert (index, new_item);
			} else {
				update_visible_items ();
			}
		}
		
		protected virtual void remove_item_without_signaling (DockItem item)
		{
			item.RemoveTime = new DateTime.now_utc ();
			item_signals_disconnect (item);
			
			internal_items.remove (item);
			item.Provider = null;
		}
		
		protected virtual void item_signals_connect (DockItem item)
		{
			item.notify["Icon"].connect (handle_item_state_changed);
			item.notify["Indicator"].connect (handle_item_state_changed);
			item.notify["State"].connect (handle_item_state_changed);
			item.notify["LastClicked"].connect (handle_item_state_changed);
			item.needs_redraw.connect (handle_item_state_changed);
			item.deleted.connect (handle_item_deleted);
		}
		
		protected virtual void item_signals_disconnect (DockItem item)
		{
			item.notify["Icon"].disconnect (handle_item_state_changed);
			item.notify["Indicator"].disconnect (handle_item_state_changed);
			item.notify["State"].disconnect (handle_item_state_changed);
			item.notify["LastClicked"].disconnect (handle_item_state_changed);
			item.needs_redraw.disconnect (handle_item_state_changed);
			item.deleted.disconnect (handle_item_deleted);
		}
		
		protected virtual void handle_item_deleted (DockItem item)
		{
			remove_item (item);
		}
		
		/**
		 * Returns if the provider accepts a drop of the given URIs.
		 *
		 * @param uris the URIs to check
		 * @return if the provider accepts a drop of the given URIs
		 */
		public virtual bool can_accept_drop (ArrayList<string> uris)
		{
			return false;
		}
		
		/**
		 * Accepts a drop of the given URIs.
		 *
		 * @param uris the URIs to accept
		 * @return if the item accepted a drop of the given URIs
		 */
		public virtual bool accept_drop (ArrayList<string> uris)
		{
			return false;
		}
	}
}
