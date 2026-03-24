// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)
import FlashController from "./flash_controller"
application.register("flash", FlashController)
import MenuController from "./menu_controller"
application.register("menu", MenuController)