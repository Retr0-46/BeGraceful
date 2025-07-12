package model

// ErrorPayload описывает формат ошибки в ответе
type ErrorPayload struct {
    Code    string `json:"code"`
    Message string `json:"message"`
}

// NewError создаёт ErrorPayload
func NewError(code, message string) ErrorPayload {
    return ErrorPayload{Code: code, Message: message}
}