package controllers

import models.TodoListItem

import play.api.mvc.{Action, AnyContent, BaseController, ControllerComponents}
import play.api.libs.json._

import javax.inject.{Singleton, Inject}

import scala.collection.mutable

@Singleton
class ApiController @Inject()(val controllerComponents: ControllerComponents) extends BaseController {
  private val todoList = new mutable.ListBuffer[TodoListItem]()
  todoList += TodoListItem(1, "test", isItDone = true)
  todoList += TodoListItem(2, "some other value", isItDone = false)
  implicit val todoListJson: OFormat[TodoListItem] = Json.format[TodoListItem]

  def getAll(): Action[AnyContent] = Action {
    if (todoList.isEmpty) {
      NoContent
    } else {
      Ok(Json.toJson(todoList))
    }
  }

  def getById(itemId: Long): Action[AnyContent] = Action {
    val foundItem = todoList.find(_.id == itemId)
    foundItem match {
      case Some(item) => Ok(Json.toJson(item))
      case None => NoContent
    }
  }

  def markAsDone(itemId: Long): Action[AnyContent] = Action {
    val foundItem = todoList.find(_.id == itemId)
    foundItem match {
      case Some(item) =>
        val my_index = todoList.indexOf(item)
        todoList(my_index) = TodoListItem(item.id, item.description, isItDone = true)
        Ok(Json.toJson(item))
      case None => NoContent
    }
  }

  def deleteAllDone(): Action[AnyContent] = Action {
    val foundItem = todoList.find(_.isItDone == true)
    todoList.remove(foundItem)

    if (todoList.isEmpty) {
      NoContent
    } else {
      Ok(Json.toJson(todoList))
    }
  }
}
