#include <gtk/gtk.h>
#include <stdio.h>
static void Shutdown(GtkWidget* widget, gpointer data) {
  system("poweroff");
}
static void activate(GtkApplication* app, gpointer user_data) {
  GtkWidget* window;
  GtkWidget* button;
  GtkWidget* button2;
  GtkWidget* button_box;
  window = gtk_application_window_new(app);
  gtk_window_set_title(GTK_WINDOW(window), "Shutdown PC");
  gtk_window_set_default_size(GTK_WINDOW(window), 200, 200);
  button_box = gtk_button_box_new(GTK_ORIENTATION_HORIZONTAL);
  gtk_container_add(GTK_CONTAINER(window), button_box);
  button2 = gtk_button_new_with_label("Shutdown");
  g_signal_connect(button2, "clicked", G_CALLBACK(Shutdown), NULL);
  gtk_container_add(GTK_CONTAINER(button_box), button2);
  button = gtk_button_new_with_label("Exit");
  g_signal_connect_swapped(button, "clicked", G_CALLBACK(gtk_widget_destroy), window);
  gtk_container_add(GTK_CONTAINER(button_box), button);
  gtk_button_box_set_layout(button_box, GTK_BUTTONBOX_EXPAND);
  gtk_widget_show_all(window);
}
int main(int argc, char** argv) {
  GtkApplication* app;
  int status;
  app = gtk_application_new("org.gtk.shutitdown", GTK_WINDOW_TOPLEVEL);
  g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);
  status = g_application_run(G_APPLICATION(app), argc, argv);
  g_object_unref(app);
  return status;
}
