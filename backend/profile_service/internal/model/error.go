package model

// ErrorPayload описывает формат ошибки
type ErrorPayload struct {
    Code    string `json:"code"`
    Message string `json:"message"`
}

// NewError конструктор
func NewError(code, message string) ErrorPayload {
    return ErrorPayload{Code: code, Message: message}
}
