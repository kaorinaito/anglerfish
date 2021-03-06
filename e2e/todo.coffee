describe('ToDoアプリシナリオテスト', ->
  emailField = passwordField = loginBtn = undefined
  allCount = remainingCount = doneCount = undefined

  hasClass = (element, cls) ->
    return element.getAttribute('class').then((classes) ->
      return classes.split(' ').indexOf(cls) != -1
    )

  beforeAll(->
    browser.get('/#/login')
    browser.waitForAngular()

    emailField = element(By.model('vm.email'))
    passwordField = element(By.model('vm.password'))
    loginBtn = element(By.css('button[type=submit]'))

    emailField.sendKeys('foo@foo.com')
    passwordField.sendKeys('foo')
    loginBtn.click()
    expect(browser.getLocationAbsUrl()).toEqual('/')

    allCount = element(By.binding('barCtrl.allCount'))
    remainingCount = element(By.binding('barCtrl.remainingCount'))
    doneCount = element(By.binding('barCtrl.doneCount'))
  )

  it('ToDoを追加する', ->
    titleField = element(By.model('registCtrl.newTitle'))
    addBtn = element(By.css('button[type=submit]'))

    title = 'New ToDo'
    titleField.sendKeys(title)
    addBtn.click()

    todoList = element.all(By.repeater('todo in vm.todoList'))
    expect(todoList.count()).toBe(3)
    expect(todoList.get(2).element(By.binding('todo.title')).getText()).toBe(title)
    expect(hasClass(todoList.get(2).element(By.model('todo.done')), 'ng-empty')).toBe(true)

    expect(allCount.getText()).toBe('4')
    expect(remainingCount.getText()).toBe('3')
    expect(doneCount.getText()).toBe('1')
  )

  it('ToDoのタイトルを編集する', ->
    todoList = element.all(By.repeater('todo in vm.todoList'))
    titleField = todoList.get(0).element(By.binding('todo.title'))
    titleFieldInput = todoList.get(0).element(By.model('todo.title'))

    expectedTitle = 'changed'
    browser.actions().doubleClick(titleField).perform()
    titleFieldInput.clear()
    titleFieldInput.sendKeys(expectedTitle)
    # Emit blur event
    todoList.get(1).element(By.binding('todo.title')).click()

    changedTitle = titleField.getText()
    expect(changedTitle).toBe(expectedTitle)
  )

  afterAll(->
    logoutBtn = element(By.css('a[ng-click="vm.logout()"]'))
    logoutBtn.click()
    expect(browser.getLocationAbsUrl()).toEqual('/login')
  )


)

