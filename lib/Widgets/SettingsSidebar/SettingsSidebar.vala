/*
* Copyright (c) 2017 elementary LLC. (https://elementary.io)
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Lesser General Public License as published by
* the Free Software Foundation, either version 2.1 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Library General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*/

public class Granite.SettingsSidebar : Gtk.ScrolledWindow {
    public Gtk.Stack stack { get; construct; }

    public SettingsSidebar (Gtk.Stack stack) {
        Object (
            hscrollbar_policy: Gtk.PolicyType.NEVER,
            stack: stack,
            width_request: 200
        );
    }

    construct {
        var listbox = new Gtk.ListBox ();
        listbox.activate_on_single_click = true;
        listbox.selection_mode = Gtk.SelectionMode.SINGLE;

        add (listbox);

        foreach (unowned Gtk.Widget child in stack.get_children ()) {
            string name;

            stack.child_get (child, "name", out name, null);

            var page = (SettingsPage) child;

            SettingsSidebarRow row;

            if (page.icon_name != null) {
                row = new SettingsSidebarRow.from_icon_name (page.icon_name, page.title);
            } else {
                row = new SettingsSidebarRow (page.display_widget, page.title);
            }

            row.name = name;
            row.header = page.header;

            page.bind_property ("status", row, "status", BindingFlags.DEFAULT);
            page.bind_property ("status-type", row, "status-type", BindingFlags.DEFAULT);

            if (page.status != null) {
                row.status = page.status;
            }

            if (page.status_type != SettingsPage.StatusType.NONE) {
                row.status_type = page.status_type;
            }

            listbox.add (row);
        }

        listbox.row_selected.connect ((row) => {
            stack.visible_child_name = ((SettingsSidebarRow) row).name;
        });

        listbox.set_header_func ((row, before) => {
            var header = ((SettingsSidebarRow) row).header;
            if (header != null) {
                row.set_header (new HeaderLabel (header));
            }
        });
    }
}