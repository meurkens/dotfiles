hs.window.animationDuration = 0

function resizeToScreen(f)
  local window = hs.window.focusedWindow()
  local frame = window:frame()
  local max = window:screen():frame()

  local new_frame = f(frame, max)
  window:setFrame(new_frame)
end

border = 5

function divideWithBorder(size, denominator, numerator)
  numerator = numerator or 1
  local part = (size - border) / denominator
  return math.floor(numerator * part - border)
end

hs.hotkey.bind({ "cmd", "ctrl" }, "h", function()
  resizeToScreen(function(currentFrame, max)
    local frame = {
      x = max.x + border,
      y = max.y + border,
      w = divideWithBorder(max.w, 2),
      h = max.h - 2 * border
    }

    if currentFrame.x == frame.x and
        currentFrame.y == frame.y and
        currentFrame.h == frame.h then
      if currentFrame.w == divideWithBorder(max.w, 2) then
        frame.w = divideWithBorder(max.w, 3, 2)
      elseif currentFrame.w == divideWithBorder(max.w, 3, 2) then
        frame.w = divideWithBorder(max.w, 3)
      end
    end

    return frame
  end)
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "l", function()
  resizeToScreen(function(currentFrame, max)
    local w = divideWithBorder(max.w, 2)
    local frame = {
      x = max.w - border - w,
      y = max.y + border,
      w = w,
      h = max.h - 2 * border
    }

    print(currentFrame)
    if currentFrame.y == frame.y and
        currentFrame.h == frame.h and
        currentFrame.x + currentFrame.w == max.w - border then
      if currentFrame.w == divideWithBorder(max.w, 2) then
        frame.w = divideWithBorder(max.w, 3)
      elseif currentFrame.w == divideWithBorder(max.w, 3) then
        frame.w = divideWithBorder(max.w, 3, 2)
      end
      frame.x = max.w - border - frame.w
    end

    return frame
  end)
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "o", function()
  resizeToScreen(function(_, max)
    local frame = {
      x = max.x + border,
      y = max.y + border,
      w = max.w - 2 * border,
      h = max.h - 2 * border
    }
    return frame
  end)
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "i", function()
  resizeToScreen(function(_, max)
    local w = 1200
    local h = 900
    local frame = {
      x = (max.w - w) / 2,
      y = (max.h - h) / 2,
      w = w,
      h = h
    }
    return frame
  end)

  local myWindow = hs.window.focusedWindow()
  local windows = hs.window.visibleWindows()
  for _, window in ipairs(windows) do
    if window ~= myWindow then
      window:application():hide()
    end
  end
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "r", function()
  hs.reload()
end)
